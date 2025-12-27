class_name EyeHolder
extends Grabbable


@onready var _content_anchors : Array[Node2D] = NodeUtils.get_children_of_type($ContentAnchors, Node2D, ArrayOf.node2D())
