extends Node

func _ready() -> void:
	for ch in get_children():
		var item := ch as CanvasItem
		if item: item.hide()
