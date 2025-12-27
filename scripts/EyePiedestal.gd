class_name EyePiedestal
extends Node2D


static var INSTANCE : EyePiedestal

@export var active_distance : float = 200.0
@export var max_scale : float = 5.0

@onready var _anchor : Node2D = $Anchor

func get_anchor(eye_part: EyePart )->Vector2:
	return _anchor.global_position

func _ready() -> void:
	if INSTANCE: ErrorUtils.report_error("EyePiedestal already has active instance {0} while new instance {1} is being created!".format([INSTANCE, self]))
	INSTANCE = self
