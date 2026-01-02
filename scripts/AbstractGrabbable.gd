class_name AbstractGrabbable
extends Node2D

@onready var _anchor_left : Node2D = NodeUtils.get_node_or_default(self, "SelfAnchor", self)
@onready var _anchor_right : Node2D = self.get_node_or_null("SelfAnchor/Right")

@onready var _outline : Node2D = NodeUtils.get_node_or_default(self, "Outline", self.get_node_or_null("Visual/Outline"))

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
	
	var is_free_to_move := ((self as Node2D) is RigidBody2D)
	
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
		if not is_free_to_move:
			self.global_position += (position_difference * INTERPOLATION_FACTOR * delta)
		

func _do_move_to_position(destination: Vector2)->void:
	var rb := (self as Node2D) as RigidBody2D
	if rb and (not rb.freeze):
		var position_delta := destination - rb.global_position
		var velocity_delta := position_delta - rb.linear_velocity
		rb.apply_force(velocity_delta)
		pass
	else:
		self.global_position = destination


func _ready() -> void:
	var holder := $Holder as Area2D
	holder.mouse_entered.connect(_on_area_2d_mouse_entered)
	holder.mouse_exited.connect(_on_area_2d_mouse_exited)
	holder.input_event.connect(_on_area_2d_input_event)


static func _try_consume_input(this: AbstractGrabbable)->bool:
	for obj in _hover_stack:
		if obj == this: return true
		if obj: return false # if obj is valid, but not `this`, then fail
	return false


var move_offset : Vector2 = Vector2.ZERO
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not can_grab(): return
	var btn := event as InputEventMouseButton
	if btn and btn.pressed and (btn.button_index == MOUSE_BUTTON_LEFT) and _try_consume_input(self):
		_is_being_grabbed = true
		on_drag_start()
		move_offset = self.global_position - btn.global_position
		

func _set_outline_visibility(new_visible: bool)->void:
	if _outline: _outline.visible = new_visible

static var _hover_stack : Array[AbstractGrabbable] = []
static func _register_hovered_over_object(object: AbstractGrabbable)->void:
	if not object in _hover_stack:
		_hover_stack.append(object)
		_update_selection_visuals()
	
static func _unregister_hovered_over_object(object: AbstractGrabbable)->void:
	_hover_stack.erase(object)
	object._set_outline_visibility(false)
	_update_selection_visuals()


static func _update_selection_visuals()->void:
	DatastructUtils.remove_all_falsy(_hover_stack)
	for i in Vector2i(1, _hover_stack.size()): _hover_stack[i]._set_outline_visibility(false)
	if _hover_stack.is_empty():
		Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder.png"))
	else:
		Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder-hand.png"), 0, Vector2(0, 30))
		_hover_stack[0]._set_outline_visibility(true)
		


func _on_area_2d_mouse_entered() -> void:
	if not can_grab(): return
	_register_hovered_over_object(self)


func _on_area_2d_mouse_exited() -> void:
	_unregister_hovered_over_object(self)
