class_name CounterCondition
extends Node

@export var desired_value :int = 1

@export var initial_value :int = 0

@onready var current_value :int = initial_value

signal on_success()
signal on_unsuccess()


func add(to_add: int)->void:
	var original_success := (current_value >= desired_value)
	current_value += to_add
	#print("{2}... adding {0} -> current: {1}".format([to_add, current_value, self.name ]))
	var new_success := (current_value >= desired_value)
	if original_success == new_success: return
	if original_success:
		assert(not new_success)
		on_unsuccess.emit()
	if new_success:
		assert(not original_success)
		on_success.emit()


func increment()->void: add(1)
func decrement()->void: add(-1)
