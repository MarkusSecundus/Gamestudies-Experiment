@tool
extends Node


@export var run: bool:
	set(_val):
		var arr : PackedInt32Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		DatastructUtils.remove_interval(arr, 1, 7)
		
		for i in arr: print(i)
