extends Grabbable

@export var price : int = 1
@export var post_purchase_scale_multiplier : float = 1.0

var is_purchased : bool = false

func on_drag_start()->void: 
	super.on_drag_start()
	_perform_purchase()
	

func can_grab()->bool: return is_purchased or (not _economy) or _economy.can_spend_money(price)

var _economy: Economy:
	get: return Economy.INSTANCE

func _ready() -> void:
	super._ready()
	if (not _economy) or (price <= 0):
		is_purchased = true
		$PriceTag.visible = false
		self.scale *= post_purchase_scale_multiplier
	$PriceTag/Label.text = "%d"%price
	await get_tree().process_frame
	if _economy:
		_economy.on_balance_change.connect(_on_balance_change)
	_on_balance_change(true)	
	
	
func _perform_purchase()->void:
	if is_purchased: return
	EyePiedestal.write_record({"type": "purchase", "what": self.name, "balance_before_purchase": _economy.current_balance, "price": self.price})
	is_purchased = true
	_economy.on_balance_change.disconnect(_on_balance_change)
	_economy.spend_money(price)
	EffectsUtils.do_fade($PriceTag, 0.0, 1.0)
	self.reparent(get_tree().current_scene)
	if post_purchase_scale_multiplier != 1.0: create_tween().tween_property(self, "scale", self.scale*post_purchase_scale_multiplier, 0.4)
	
func _should_place_on_start()->bool: return price <= 0
	
	
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
