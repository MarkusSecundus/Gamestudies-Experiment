extends TextureButton


@export var target: Sprite2D
@export var hover_scale : float = 1.6

func _on_pressed() -> void:
	var to_set := self.texture_normal
	if target.texture == to_set:
		target.visible = not target.visible
	else:
		target.visible = true
		target.texture = to_set



const HOVER_EFFECT_BUILDUP_DURATION : float = 0.1 

@onready var button_scale_tween := EffectsUtils.TweenWrapper.new(self)

func _on_mouse_entered() -> void:
	button_scale_tween.do_property(self, 'scale', Vector2.ONE * hover_scale, HOVER_EFFECT_BUILDUP_DURATION)


func _on_mouse_exited() -> void:
	button_scale_tween.do_property(self, 'scale', Vector2.ONE, HOVER_EFFECT_BUILDUP_DURATION)



const BUTTON_PRESSED_COLOR :=Color(0.8, 0.8, 0.8)

func _on_button_down() -> void:
	self.self_modulate = BUTTON_PRESSED_COLOR

func _on_button_up() -> void:
	self.self_modulate = Color.WHITE
