class_name OrderingConfiguration
extends Resource

@export var z_index : int = 0
@export var z_as_relative : bool = true
@export var y_sort_enabled : bool = false

func apply(node: CanvasItem)->void:
	node.z_index = self.z_index
	node.z_as_relative = self.z_as_relative
	node.y_sort_enabled = self.y_sort_enabled
