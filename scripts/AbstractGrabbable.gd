class_name AbstractGrabbable
extends Node2D

@onready var _anchor_left : Node2D = NodeUtils.get_node_or_default(self, "SelfAnchor", self)
@onready var _anchor_right : Node2D = self.get_node_or_null("SelfAnchor/Right")

func get_only_anchor()->Vector2: return get_left_anchor()
func get_left_anchor()->Vector2: return _anchor_left.global_position
func get_right_anchor()->Vector2: return _anchor_right.global_position

func get_length()->float: return get_left_anchor().distance_to(get_right_anchor())

var _is_being_grabbed :bool = false

func on_drag_start()->void: pass
func on_drag_end()->void: pass
func get_position_difference()->Vector2: return Vector2.ZERO
func can_grab()->bool: return true

func perform_drag(cursor_position: Vector2, _delta: float)->void:
	self.global_position = cursor_position

func _process(delta: float) -> void:
	const INTERPOLATION_FACTOR = 2
	
	var drag_was_performed := false
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if _is_being_grabbed:
			perform_drag(get_viewport().get_mouse_position() + move_offset, delta)
			drag_was_performed = true
	else:
		var was_being_grabbed := _is_being_grabbed
		_is_being_grabbed = false
		if was_being_grabbed:
			on_drag_end()
	if not drag_was_performed:
		var position_difference := get_position_difference()
		self.global_position += (position_difference * INTERPOLATION_FACTOR * delta)
		


func _ready() -> void:
	var holder := $Holder as Area2D
	holder.mouse_entered.connect(_on_area_2d_mouse_entered)
	holder.mouse_exited.connect(_on_area_2d_mouse_exited)
	holder.input_event.connect(_on_area_2d_input_event)

static var _last_frame_when_input_was_consumed : int = -1
static var _last_input_consumer : AbstractGrabbable = null
static func _try_consume_input(this: AbstractGrabbable)->bool:
		var current_frame_count := Engine.get_frames_drawn()
		if _last_frame_when_input_was_consumed == current_frame_count: 
			return (_last_input_consumer == this)
		_last_frame_when_input_was_consumed = current_frame_count
		_last_input_consumer = this
		return true


var move_offset : Vector2 = Vector2.ZERO
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not can_grab(): return
	var btn := event as InputEventMouseButton
	if btn and btn.pressed and (btn.button_index == MOUSE_BUTTON_LEFT) and _try_consume_input(self):
		_is_being_grabbed = true
		on_drag_start()
		move_offset = self.global_position - btn.global_position
		

func _on_area_2d_mouse_entered() -> void:
	if not can_grab(): return
	if not _try_consume_input(self): return
	Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder-hand.png"), 0, Vector2(0, 30))


func _on_area_2d_mouse_exited() -> void:
	if not _try_consume_input(self): return
	if not _is_being_grabbed:
		Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder.png"))
