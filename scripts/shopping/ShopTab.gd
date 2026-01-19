extends AbstractGrabbable


@export var _open_position : Node2D
@onready var _og_position : Vector2 = self.global_position

var _is_opened : bool = false
var _current_target_position : Vector2:
	get: return _open_position.global_position if _is_opened else _og_position

func on_drag_end()->void: 
	_is_opened = not _is_opened
func get_position_difference()->Vector2: return _current_target_position - self.global_position

func perform_drag(cursor_position: Vector2, _delta: float)->void:
	self.global_position.y = clamp( cursor_position.y, _og_position.y, _open_position.global_position.y)
