@tool
extends Node


@export var run: bool:
	set(_val):
		var arr : Dictionary[int, String] = {1:"abc", 2:"FDDD", 41: "Toto je text!"}		
		for i in arr.values(): print(i)
