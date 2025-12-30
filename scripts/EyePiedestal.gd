class_name EyePiedestal
extends AbstractGrabbable


static var INSTANCE : EyePiedestal

@export var active_distance : float = 200.0
@export var submit_distance : float = 150.0

@onready var _anchor_parent : Node2D = $Anchors
@onready var _generic_anchor : Node2D = $Anchors/Generic

func get_anchor(eye_part: EyePart)->Node2D:
	var personalised_anchor := _anchor_parent.get_node_or_null(NodePath(eye_part.name)) as Node2D
	if personalised_anchor: 
		return personalised_anchor
	return _generic_anchor

func _ready() -> void:
	super._ready()
	if INSTANCE: ErrorUtils.report_error("EyePiedestal already has active instance {0} while new instance {1} is being created!".format([INSTANCE, self]))
	INSTANCE = self


func can_grab()->bool: return _chosen_eye_parts.size() == 4 and DatastructUtils.all(_chosen_eye_parts.values(), func(e)->bool: return !!e)

var _chosen_eye_parts : Dictionary[EyePart.PartType, EyePart] = {EyePart.PartType.EyeShape: null, EyePart.PartType.Eyebrow: null, EyePart.PartType.Iris: null, EyePart.PartType.Pupil: null}

func add_eye_part(part: EyePart)->void:
	var previous := _chosen_eye_parts[part.type]
	if previous:
		previous._piedestal_anchor = null
	_chosen_eye_parts[part.type] = part

func remove_eye_part(part: EyePart)->void:
	if _chosen_eye_parts[part.type] == part:
		_chosen_eye_parts[part.type] = null
