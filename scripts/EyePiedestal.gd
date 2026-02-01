class_name EyePiedestal
extends AbstractGrabbable


static var INSTANCE : EyePiedestal

@export var active_distance : float = 200.0
@export var submit_destination : Node2D
@export var submit_distance : float = 100.0
@export var customer_image : CanvasItem
@export var customer_triggered_alpha = 1.3
@onready var _customer_base_alpha :float = customer_image.modulate.a

@onready var _anchor_parent : Node2D = $Anchors
@onready var _generic_anchor : Node2D = $Anchors/Generic

signal on_submitted()

func get_anchor(eye_part: EyePart)->Node2D:
	var personalised_anchor := _anchor_parent.get_node_or_null(NodePath(eye_part.name)) as Node2D
	if personalised_anchor: 
		return personalised_anchor
	return _generic_anchor

var _og_position : Vector2
var _og_scale : Vector2
var _og_modulate : Color

func _ready() -> void:
	super._ready()
	self._og_position = self.global_position
	self._og_scale = self.scale
	self._og_modulate = self.modulate
	if INSTANCE: ErrorUtils.report_error("EyePiedestal already has active instance {0} while new instance {1} is being created!".format([INSTANCE, self]))
	INSTANCE = self

var _last_can_grab :bool= false
func _process(delta: float) -> void:
	super._process(delta)
	var can_grab := self.can_grab()
	if _last_can_grab != can_grab:
		if can_grab: $HolderHidingCondition.increment()
		else: $HolderHidingCondition.decrement()
	_last_can_grab = can_grab
	if not can_grab: 
		if customer_image: customer_image.modulate.a = _customer_base_alpha
		return
	var distance_to_submit := self.global_position.distance_to(submit_destination.global_position)
	var distance_to_origin := self.global_position.distance_to(_og_position)
	var t:float = distance_to_origin / (distance_to_origin + distance_to_submit)
	self.scale = lerp(_og_scale, submit_destination.scale, t) as Vector2
	self.modulate = lerp(_og_modulate, submit_destination.modulate, t) as Color
	if customer_image:
		customer_image.modulate.a = customer_triggered_alpha if ((distance_to_submit <= self.submit_distance) and (not _is_submitted) and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) else _customer_base_alpha


func on_drag_start()->void: pass
func get_position_difference()->Vector2: 
	var target_pos := submit_destination.global_position if _is_submitted else _og_position
	return target_pos - self.global_position

var _is_submitted : bool = false

func on_drag_end()->void: 
	if _is_in_submit_area():
		do_submit()

func _is_in_submit_area()->bool: return self.global_position.distance_to(submit_destination.global_position) <= submit_distance

func can_grab()->bool: return _chosen_eye_parts.size() == 4 and DatastructUtils.all(_chosen_eye_parts.values(), func(e)->bool: return !!e)

var _chosen_eye_parts : Dictionary[EyePart.PartType, EyePart] = {EyePart.PartType.EyeShape: null, EyePart.PartType.Eyebrow: null, EyePart.PartType.Iris: null, EyePart.PartType.Pupil: null}

static func _get_eye_part_name(part: EyePart)->String:
	if not part: return "<nil>"
	return part.name

func add_eye_part(part: EyePart)->void:
	write_record({"type": "add_part", "part": _get_eye_part_name(part)})
	var previous := _chosen_eye_parts[part.type]
	if previous and (previous != part):
		previous._piedestal_anchor = null
	_chosen_eye_parts[part.type] = part

func remove_eye_part(part: EyePart, suppress_report: bool = false)->void:
	if not suppress_report: write_record({"type": "remove_part", "part": _get_eye_part_name(part)})
	if _chosen_eye_parts[part.type] == part:
		_chosen_eye_parts[part.type] = null


var _question_idx :int = 0
func do_submit()->void:
	assert(can_grab())
	print("Submitted question %d"%_question_idx)
	_is_submitted = true
	_record_answer()
	on_submitted.emit()
	_do_submit_visual_effect()

var _submit_fade_out_duration_seconds : float = 1.0
var _submit_fade_in_duration_seconds : float = 1.0

func _do_submit_visual_effect()->void:
	var tw := create_tween()
	var target_modulate := self.modulate
	target_modulate.a = 0.0
	var tweener := tw.tween_property(self, "modulate", target_modulate, _submit_fade_out_duration_seconds)
	await tweener.finished
	
	self.global_position = _og_position
	self.scale = _og_scale
	self._is_submitted = false
	self._question_idx += 1
	
	tw = create_tween()
	for eye_part_raw in _chosen_eye_parts.values():
		var eye_part := eye_part_raw as EyePart
		eye_part._piedestal_anchor = null
		remove_eye_part(eye_part, true)
		eye_part.global_position = eye_part._holder_anchor.global_position
		var part_og_modulate := eye_part.modulate
		eye_part.modulate.a = 0
		tw.tween_property(eye_part, "modulate", part_og_modulate, _submit_fade_in_duration_seconds)
	tw.tween_property(self, "modulate", _og_modulate, _submit_fade_in_duration_seconds)

func _record_answer()->void:
	var answer : Dictionary[String, Variant]
	answer.type = "submit_answer"
	answer.question_idx = _question_idx
	answer.eye_shape = _chosen_eye_parts[EyePart.PartType.EyeShape].name
	answer.eyebrow = _chosen_eye_parts[EyePart.PartType.Eyebrow].name
	answer.iris = _chosen_eye_parts[EyePart.PartType.Iris].name
	answer.pupil = _chosen_eye_parts[EyePart.PartType.Pupil].name
	write_record(answer)

static var logfile_web : String = ""

const NO_RECORD_PLATFORMS : PackedStringArray = []
static func write_record(record: Dictionary[String, Variant])->void:
	if OS.get_name() in NO_RECORD_PLATFORMS: return
	record["timestamp"] = Time.get_time_string_from_system()
	var ANSWERS_PATH = "eyeshop.log"
	if OS.get_name() == "Android":
		ANSWERS_PATH = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS).path_join(ANSWERS_PATH)
	var is_append :bool = true
	var to_append := JSON.stringify(record, "\t")
	
	var is_web :bool = OS.get_name() == "Web"
	var f : FileAccess
	
	if is_web:
		is_append = not logfile_web.is_empty()
	else:
		f = FileAccess.open(ANSWERS_PATH, FileAccess.READ_WRITE)
		if not f: 
			f = FileAccess.open(ANSWERS_PATH, FileAccess.WRITE)
			is_append = false
	if is_append:
		to_append = ", " + to_append
	if is_web:
		logfile_web += to_append
	else:
		f.seek_end()
		f.store_line(to_append)
		f.close()

static func flush_record()->void:
	if OS.get_name() != "Web": return
	var result := "[" + logfile_web + "]"
	JavaScriptBridge.download_buffer(result.to_ascii_buffer(), "eyeshop.log")
