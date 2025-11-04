extends TextureButton


@export var assigned_shape: CanvasItem

func _on_pressed() -> void:
	var original_hidden_state = assigned_shape.visible
	(assigned_shape.get_parent() as CanvasItem).show()
	for ch in assigned_shape.get_parent().get_children():
		(ch as CanvasItem).hide()
	assigned_shape.visible = not original_hidden_state



const SCALE_CHANGE_ON_HOVER : float = 1.2
const HOVER_EFFECT_BUILDUP_DURATION : float = 0.1 

@onready var button_scale_tween := EffectsUtils.TweenWrapper.new(self)

func _on_mouse_entered() -> void:
	button_scale_tween.do_property(self, 'scale', Vector2.ONE * SCALE_CHANGE_ON_HOVER, HOVER_EFFECT_BUILDUP_DURATION)


func _on_mouse_exited() -> void:
	button_scale_tween.do_property(self, 'scale', Vector2.ONE, HOVER_EFFECT_BUILDUP_DURATION)



const BUTTON_PRESSED_COLOR :=Color(0.8, 0.8, 0.8)

func _on_button_down() -> void:
	self.self_modulate = BUTTON_PRESSED_COLOR

func _on_button_up() -> void:
	self.self_modulate = Color.WHITE
