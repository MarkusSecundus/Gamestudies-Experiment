extends Node2D


@onready var original_position : Vector2 = self.position

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_being_dragged:
			self.global_position = get_viewport().get_mouse_position() + move_offset
	else:
		is_being_dragged = false
		self.position = lerp(self.position, original_position, 2*delta)

var move_offset : Vector2 = Vector2.ZERO
var is_being_dragged : bool = false
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not _is_finished(): return
	var btn := event as InputEventMouseButton
	if btn:
		is_being_dragged = true
		move_offset = self.global_position - btn.global_position

func _is_finished()->bool:
	return $Eye.visible and $Eyebrow.visible and $Iris.visible and $Pupil.visible

func _on_area_2d_mouse_entered() -> void:
	if not _is_finished(): return
	Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder-hand.png"))


func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder.png"))
