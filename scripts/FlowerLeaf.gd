extends Bone2D

@export_range(0.0, 180.0) var rotation_interval_deg = 10
@export var rotation_change_speed : float = 1.0

var rotation_interval: float:
	get: return deg_to_rad(rotation_interval_deg)
@onready var _rb : RigidBody2D = NodeUtils.get_ancestor_component_of_type(self, RigidBody2D) as RigidBody2D
@onready var _og_rotation :float = self.rotation

@export var linear_velocity_change_factor : float = 1.0
var target_rotation : float = 0.0
var current_rotation : float = 0.0
var rotation_speed_factor = 1.0

var normalization_factor : float = 0.5

func _process(delta: float) -> void:
	if not visible: return
	target_rotation += ((-signf(self.global_rotation) * _rb.linear_velocity.y) -_rb.linear_velocity.x) * linear_velocity_change_factor * delta
	target_rotation = clampf(target_rotation, -rotation_interval, +rotation_interval)
	target_rotation = lerpf(target_rotation, 0.0, normalization_factor * delta)
	current_rotation = lerpf(current_rotation, target_rotation, rotation_speed_factor * delta)
	self.rotation = _og_rotation + current_rotation
