extends Grabbable

@export var price : int = 1


var is_purchased : bool = false

func on_drag_start()->void: 
	super.on_drag_start()
	_perform_purchase()
	

func can_grab()->bool: return is_purchased or _economy.can_spend_money(price)

var _economy: Economy:
	get: return Economy.INSTANCE

func _ready() -> void:
	super._ready()
	$PriceTag/Label.text = "%d"%price
	await get_tree().process_frame
	_economy.on_balance_change.connect(_on_balance_change)
	_on_balance_change(true)	
	
	
func _perform_purchase()->void:
	if is_purchased: return
	is_purchased = true
	_economy.on_balance_change.disconnect(_on_balance_change)
	_economy.spend_money(price)
	EffectsUtils.do_fade($PriceTag, 0.0, 1.0)
	self.reparent(get_tree().root)
	
func _should_place_on_start()->bool: return false
	
	
const _unavailable_alpha :float = 0.5
const _available_alpha :float = 1.0
var _previous_was_affordable : bool = false
var tw := EffectsUtils.TweenWrapper.new(self)
func _on_balance_change(force : bool = false)->void:
	if is_purchased: return
	var is_affordable : bool = can_grab()
	if (is_affordable != _previous_was_affordable) or force:
		var desired_alpha := _economy._purchasable_available_alpha if is_affordable else _economy._purchasable_unavailable_alpha
		tw.do_fade($Visual, desired_alpha, _economy._purchasable_fade_duration_seconds)
	_previous_was_affordable = is_affordable
