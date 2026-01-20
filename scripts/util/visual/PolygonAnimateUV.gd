@tool
extends Polygon2D

@export var uv_shift : Vector2:
	get: return uv_shift
	set(val): 
		if val == uv_shift: return
		var delta : Vector2 = val - uv_shift
		uv_shift = val
		var new_uv = self.uv
		for i in new_uv.size():
			new_uv[i] += delta
		uv = new_uv
		
@export var shift_velocity : Vector2 = Vector2.ZERO
@export var _do_reset: bool:
	get: return false
	set(_val):
		_preview = false
		uv_shift = Vector2.ZERO

@export var _preview : bool = false

func _ready() -> void:
	uv_shift = Vector2.ZERO

func _process(delta: float) -> void:
	if Engine.is_editor_hint() and (not _preview): return
	uv_shift += shift_velocity * delta
