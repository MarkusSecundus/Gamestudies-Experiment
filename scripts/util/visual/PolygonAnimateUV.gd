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
		
