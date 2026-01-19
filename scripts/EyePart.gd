class_name EyePart
extends AbstractGrabbable

enum PartType{
	EyeShape, Eyebrow, Iris, Pupil
}

@export var type : PartType

var _holder_anchor : Node2D

var _piedestal_anchor : Node2D

var _active_anchor : Node2D:
	get:
		if _piedestal_anchor: return _piedestal_anchor
		return _holder_anchor

var _original_scale : Vector2

var _piedestal : EyePiedestal:
	get: return EyePiedestal.INSTANCE

@onready var _ordering_config: GrabbableOrderingConfiguration = _choose_ordering_config(type)
static func _choose_ordering_config(part_type: EyePart.PartType)->GrabbableOrderingConfiguration:
	if part_type == PartType.EyeShape: return load("res://ordering_configs/eye_shape_ordering.tres") as GrabbableOrderingConfiguration
	if part_type == PartType.Eyebrow: return load("res://ordering_configs/eyebrow_ordering.tres") as GrabbableOrderingConfiguration
	if part_type == PartType.Iris: return load("res://ordering_configs/iris_ordering.tres") as GrabbableOrderingConfiguration
	if part_type == PartType.Pupil: return load("res://ordering_configs/pupil_ordering.tres") as GrabbableOrderingConfiguration
	return null


func _ready() -> void:
	super._ready()
	self._original_scale = self.scale
	await get_tree().process_frame
	var holder := get_parent() as EyeCabinet
	if holder: holder.try_add_eye_part(self)


func _process(delta: float) -> void:
	super._process(delta)
	if not _piedestal: return
		
	var target_anchor := _piedestal.get_anchor(self)
	var distance_to_target_anchor := self.get_only_anchor().distance_to(target_anchor.global_position)
	var distance_to_home_anchor := self.get_only_anchor().distance_to(_holder_anchor.global_position)
	#var distance_between_home_and_target_anchor := target_anchor.distance_to(_holder_anchor.global_position)
	var target_t = clampf(distance_to_target_anchor, 0, _piedestal.active_distance) / _piedestal.active_distance
	var home_t = 1.0 - (clampf(distance_to_home_anchor, 0, _piedestal.active_distance) / _piedestal.active_distance)
	var t = lerpf(home_t, target_t, distance_to_home_anchor / (distance_to_target_anchor + distance_to_home_anchor))
	var new_scale := lerp(target_anchor.scale, _original_scale, t) as Vector2
	var distance_from_active_anchor := get_position_difference().length()
	var distance_from_the_cabinet := (_holder_anchor.global_position - self.get_only_anchor()).length()
	if (not _is_being_grabbed) and (distance_from_active_anchor < 40.0) and (self.get_parent() != _active_anchor.get_parent().get_parent()):
		self.reparent(_active_anchor.get_parent().get_parent())
		_ordering_config.when_stationary.apply(self)
	if new_scale.x > self.scale.x: #if we are very close to the cabinet, we don't want to increase our size
		if distance_from_the_cabinet < 40.0: return
	self.scale = new_scale
	

func set_anchor(new_anchor : Node2D)->void:
	_holder_anchor = new_anchor


func on_drag_start()->void: 
	self.reparent(get_tree().root)
	_ordering_config.when_moving.apply(self)
func on_drag_end()->void: 
	var piedestal_anchor := _piedestal.get_anchor(self)
	var distance_to_piedestal := _piedestal.global_position.distance_to(self.global_position)
	print("piedestal distance: {0} (required {1})".format([distance_to_piedestal, _piedestal.submit_distance]))
	if distance_to_piedestal < _piedestal.submit_distance:
		self._piedestal_anchor = piedestal_anchor
		_piedestal.add_eye_part(self)
	else:
		self._piedestal_anchor = null
		_piedestal.remove_eye_part(self)


func get_position_difference()->Vector2: 
	if _active_anchor: return _active_anchor.global_position - self.get_only_anchor() 
	print("No holder anchor: {0}".format([self.name]))
	return Vector2.ZERO
