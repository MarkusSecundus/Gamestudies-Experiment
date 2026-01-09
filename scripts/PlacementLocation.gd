class_name PlacementLocation
extends Node2D



class Segment:
	extends RefCounted
	
	var parent : PlacementLocation
	var left: Vector2
	var right: Vector2
	var length: float:
		get: return left.distance_to(right)
	var left_to_right_direction: Vector2:
		get: return (right - left).normalized()
	var inhabitant: Grabbable
	
	var idx : int:
		get: return parent.segments.find(self)
	
	var is_empty: bool:
		get: return self.inhabitant == null
		
	@warning_ignore("shadowed_variable")
	func _init(parent: PlacementLocation, left: Vector2, right: Vector2, inhabitant: Grabbable) -> void:
		self.parent = parent
		self.left = left
		self.right = right
		self.inhabitant = inhabitant

	func _to_string() -> String: return "{0}[{1}](total size <{2}, {3}>)".format([self.parent.name, self.idx, self.left, self.right])

	func do_leave()->Segment:
		parent.remove(self.idx)
		return null


@onready var _left : Node2D = self
@onready var _right : Node2D = $Right

@onready var segments : Array[Segment] = [Segment.new(self, _left.global_position, _right.global_position, null)]


func place(obj: Grabbable, segment_idx: int, left: Vector2, right: Vector2)->void:
	var og_segment := segments[segment_idx]
	#print("Placing {0} to interval <{1},{2}> of {3}".format([obj, left, right, og_segment]))
	if not og_segment.is_empty: ErrorUtils.report_error("{0}.. Attempting to populate a segment (<{1},{2}>) by {3}, but it's already occupied by {4}".format([self, left, right, obj, og_segment.inhabitant]))
	if not GeometryUtils.epsilon_equals2D(left, og_segment.left):
		segments.insert(segment_idx, Segment.new(self, og_segment.left, left, null))
		segment_idx += 1
	if not GeometryUtils.epsilon_equals2D(og_segment.right, right):
		segments.insert(segment_idx + 1, Segment.new(self, right, og_segment.right, null))
	og_segment.inhabitant = obj
	og_segment.left = left
	og_segment.right = right
	obj.place(og_segment)
	

func remove(segment_idx: int)->void:
	var range_begin_idx :int = segment_idx
	var range_end_idx : int = segment_idx
	while range_begin_idx > 0 and segments[range_begin_idx - 1].is_empty:
		range_begin_idx = range_begin_idx - 1
	while range_end_idx < (segments.size() - 1) and segments[range_end_idx + 1].is_empty:
		range_end_idx = range_end_idx + 1
	var leftmost := segments[range_begin_idx].left
	var rightmost := segments[range_end_idx].right
	segments = DatastructUtils.remove_interval(segments, range_begin_idx, range_end_idx + 1)
	segments.insert(range_begin_idx, Segment.new(self, leftmost, rightmost, null))
	
