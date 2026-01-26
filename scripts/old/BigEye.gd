extends Node2D


@export var destination : Node2D
@export var color_distance_interval := Vector2(100, 10)
@export var give_distance : float = 120.0

@onready var original_position : Vector2 = self.position


func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if is_being_dragged:
			self.global_position = get_viewport().get_mouse_position() + move_offset
	else:
		if is_being_dragged and (get_distance_to_destination() <= give_distance):
			self.position = original_position
			GameManager.INSTANCE.record_answers(get_current_answer())
			hide_all()
			GameManager.INSTANCE.next_question()
		is_being_dragged = false
		self.position = lerp(self.position, original_position, 2*delta)
		
	set_color(get_distance_to_destination())

func get_distance_to_destination() -> float:
	return (self.global_position - move_offset).distance_to(destination.global_position)

func set_color(distance : float)->void:
	var weight : float = (clamp(distance, color_distance_interval.y, color_distance_interval.x) - color_distance_interval.y) / (color_distance_interval.x - color_distance_interval.y)
	self.modulate = lerp(Color.RED, Color.WHITE, weight)
	#print("distance: {0}, weight: {1}, mod: {2}".format([distance, weight, self.modulate]))

func _is_finished()->bool:
	return $Eye.visible and $Eyebrow.visible and $Iris.visible and $Pupil.visible

func hide_all()->void:
	$Eye.hide()
	$Eyebrow.hide() 
	$Iris.hide() 
	$IrisLineart.hide() 
	$Pupil.hide()

func get_current_answer()->Answer:
	var ret := Answer.new()
	ret.eye = ($Eye.texture).resource_path
	ret.eyebrow = ($Eyebrow.texture).resource_path
	ret.iris = ($Iris.texture).resource_path
	ret.pupil = ($Pupil.texture).resource_path
	return ret

var move_offset : Vector2 = Vector2.ZERO
var is_being_dragged : bool = false
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not _is_finished(): return
	var btn := event as InputEventMouseButton
	if btn:
		is_being_dragged = true
		move_offset = self.global_position - btn.global_position

func _on_area_2d_mouse_entered() -> void:
	if not _is_finished(): return
	Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder-hand.png"))


func _on_area_2d_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(preload	("res://art/cursor/cursor-placeholder-smaller.png"))
