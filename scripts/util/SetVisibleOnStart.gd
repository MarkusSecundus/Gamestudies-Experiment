extends CanvasItem

@export var desired_visibility : bool = true

func _init() -> void:
	self.visible = desired_visibility

func _enter_tree() -> void:
	self.visible = desired_visibility
