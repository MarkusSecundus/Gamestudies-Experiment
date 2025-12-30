@tool
extends Node


@export var run: bool:
	set(_val):
		var i := DatastructUtils.Wrapper.new(10)
		var c : Callable = func(): 
			i.value += 1
			print(i.value)
		c.call()
		c.call()
		c.call()
