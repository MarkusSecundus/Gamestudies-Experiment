extends Node


func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(String(meta))
