class_name Grabbable
extends AbstractGrabbable


func get_left_anchor()->Vector2: return _anchor_left.global_position
func get_right_anchor()->Vector2: return _anchor_right.global_position

func get_length()->float: return get_left_anchor().distance_to(get_right_anchor())

var _placement : PlacementLocation.Segment = null

func on_drag_start()->void: 
	EyePiedestal.write_record({"type": "grab_object", "object": self.name, "original_placement": (_placement.name if _placement else "<nil>")})
	if _placement:
		_placement =  _placement.do_leave()
	var rb := self as Node2D as RigidBody2D
	if rb: rb.freeze = true
func on_drag_end()->void: 
	if PlacementLocations.INSTANCE:
		PlacementLocations.INSTANCE.do_place(self)
	EyePiedestal.write_record({"type": "place_object", "object": self.name, "destination": (_placement.name if _placement else "<nil>")})
	var rb := self as Node2D as RigidBody2D
	if rb: rb.freeze = false
func get_position_difference()->Vector2:
	if not _placement: return Vector2.ZERO
	return _placement.left - get_left_anchor()

func place(location: PlacementLocation.Segment)->void:
	self._placement = location


func _should_place_on_start()->bool: return true

func _ready() -> void:
	super._ready()
	if _should_place_on_start():
		if not self.is_visible_in_tree():
			while true:
				await self.visibility_changed
				if self.is_visible_in_tree(): break
		await get_tree().process_frame
		PlacementLocations.INSTANCE.do_place(self)
