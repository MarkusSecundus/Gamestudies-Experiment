@tool
class_name EyeCabinet
extends Grabbable

@export var _show_label:bool:
	get:
		var lbl := get_node_or_null("Visual/Label") as CanvasItem
		return lbl and lbl.visible
	set(value): 
		var lbl := get_node_or_null("Visual/Label") as CanvasItem
		if lbl: lbl.visible = value
		
@export var _label_text:String:
	get:
		var lbl := get_node_or_null("Visual/Label/Text") as Label
		return "" if not lbl else lbl.text
	set(value): 
		var lbl := get_node_or_null("Visual/Label/Text") as Label
		if lbl: lbl.text = value

@onready var _content_anchors : Array[Node2D] = NodeUtils.get_children_of_type($ContentAnchors, Node2D, ArrayOf.node2D())

func _ready() -> void:
	if Engine.is_editor_hint(): return
	super._ready()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	super._process(delta)

func try_add_eye_part(eye_part: EyePart)->bool:
	var eye_anchor := eye_part.get_only_anchor()
	var closest_anchor : Node2D = DatastructUtils.find_min(_content_anchors, func(a: Node2D): return INF if (a.get_child_count() > 0) else a.global_position.distance_squared_to(eye_anchor) ) as Node2D
	
	if not closest_anchor: return false
	
	eye_part.set_anchor(closest_anchor)
	eye_part.reparent(closest_anchor)
	return true
