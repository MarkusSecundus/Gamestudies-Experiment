class_name FaderSingleton
extends CanvasItem

static var INSTANCE : FaderSingleton

func _init() -> void:
	assert(not INSTANCE)
	INSTANCE = self
