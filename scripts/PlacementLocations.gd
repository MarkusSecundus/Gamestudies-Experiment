class_name PlacementLocations
extends Node


@onready var _locations : Array[PlacementLocation] = NodeUtils.get_children_of_type(self, PlacementLocation, _array_of_PlacementLocation())

static var INSTANCE : PlacementLocations = null 

func _ready() -> void:
	if INSTANCE: ErrorUtils.report_error("Placement Locations already has active instance {0} while new instance {1} is being created!".format([INSTANCE, self]))
	INSTANCE = self

func do_place(g: Grabbable)->void:
	var left := g.get_left_anchor()
	var right := g.get_right_anchor()
	var obj_length = g.get_length()
	
	var best_distance :float = INF
	var best_location : PlacementLocation = null
	var best_segment_idx : int = -1
	var best_left : Vector2 = Vector2.ZERO
	var best_right : Vector2 = Vector2.ZERO
	
	for loc in _locations:
		for segment_idx in loc.segments.size():
			var segment := loc.segments[segment_idx]
			if not segment.is_empty: continue
			if segment.length < obj_length: continue
			
			var closest_points := Geometry2D.get_closest_points_between_segments(left, right, segment.left, segment.right)
			var closest_point_on_grabbable := closest_points[0]
			var closest_point_on_segment := closest_points[1]
			var distance := closest_point_on_grabbable.distance_to(closest_point_on_segment)
			if distance >= best_distance: continue
			
			var closest_left := Geometry2D.get_closest_point_to_segment(left, segment.left, segment.right)
			var closest_right := Geometry2D.get_closest_point_to_segment(right, segment.left, segment.right)
			var right_if_we_use_closest_left : Vector2 = closest_left + (segment.left_to_right_direction*obj_length)
			var left_if_we_use_closest_right : Vector2 = closest_right - (segment.left_to_right_direction*obj_length)
			var chosen_left : Vector2
			var chosen_right : Vector2
			
			
			if GeometryUtils.point_is_on_segment(right_if_we_use_closest_left, segment.left, segment.right):
				chosen_left = closest_left
				chosen_right = right_if_we_use_closest_left
			elif GeometryUtils.point_is_on_segment(left_if_we_use_closest_right, segment.left, segment.right):
				chosen_left = left_if_we_use_closest_right
				chosen_right = closest_right
			elif right_if_we_use_closest_left.distance_squared_to(segment.right) < left_if_we_use_closest_right.distance_squared_to(segment.left):
				chosen_right = segment.right
				chosen_left = segment.right - (segment.left_to_right_direction*obj_length)
			else:
				chosen_left = segment.left
				chosen_right = segment.left + (segment.left_to_right_direction*obj_length)
			
			if chosen_left.x >= chosen_right.x:
				ErrorUtils.report_error("Wrong interval computation - got <{0}, {1}>".format([chosen_left, chosen_right]))
			
			best_left = chosen_left
			best_right = chosen_right
			best_distance = distance
			best_location = loc
			best_segment_idx = segment_idx
	
	best_location.place(g, best_segment_idx, best_left, best_right)




















static func _array_of_PlacementLocation()->Array[PlacementLocation]: return []
