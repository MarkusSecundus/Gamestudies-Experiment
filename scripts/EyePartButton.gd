extends TextureButton

const scale_change : float = 1.2

@export var assigned_shape: CanvasItem

func _on_pressed() -> void:
	(assigned_shape.get_parent() as CanvasItem).show()
	for ch in assigned_shape.get_parent().get_children():
		(ch as CanvasItem).hide()
	assigned_shape.show()

func _on_mouse_entered() -> void:
	self.scale = Vector2.ONE * scale_change


func _on_mouse_exited() -> void:
	self.scale = Vector2.ONE


func _on_button_down() -> void:
	self.self_modulate = Color(0.8, 0.8, 0.8)

func _on_button_up() -> void:
	self.self_modulate = Color.WHITE
