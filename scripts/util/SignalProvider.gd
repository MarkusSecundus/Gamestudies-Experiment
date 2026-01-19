class_name SignalProvider
extends Node

@export var _do_emit_btn:bool:
	set(_val):
		print("emiting the signal by button press!")
		the_signal.emit()

signal the_signal();

func do_emit()->void:
	the_signal.emit()
