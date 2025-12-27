class_name EyePart
extends AbstractGrabbable


var _holder_anchor : Node2D

var _original_scale : Vector2

func _ready() -> void:
	super._ready()
	self._original_scale = self.scale
	await get_tree().process_frame
	var holder := get_parent() as EyeHolder
	if holder: holder.try_add_eye_part(self)


func _process(delta: float) -> void:
	super._process(delta)
		
	var target_anchor := EyePiedestal.INSTANCE.get_anchor(self)
	var distance_to_anchor := self.get_only_anchor().distance_to(target_anchor)
	var t = clampf(distance_to_anchor, 0, EyePiedestal.INSTANCE.active_distance) / EyePiedestal.INSTANCE.active_distance
	var scale_multiplier := lerpf(EyePiedestal.INSTANCE.max_scale, 1.0, t)
	var new_scale := _original_scale * scale_multiplier
	if new_scale.x > self.scale.x:
		if get_position_difference().length() < 40.0: return
	self.scale = new_scale
	

func set_anchor(new_anchor : Node2D)->void:
	_holder_anchor = new_anchor


func on_drag_start()->void: pass
func on_drag_end()->void: pass
func get_position_difference()->Vector2: 
	if _holder_anchor: return _holder_anchor.global_position - self.get_only_anchor() 
	print("No holder anchor: {0}".format([self.name]))
	return Vector2.ZERO
