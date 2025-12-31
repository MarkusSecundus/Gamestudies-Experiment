class_name PrettyTextBox
extends Control


@export var seconds_per_char := 0.05
@export_range(0.0, 1.0) var char_sound_chance = 0.03 
@export var sounds_per_char : Array[AudioStream]
@export var sound_pitch_range := Vector2(0.8, 0.9)

@export var print_on_start : bool = false
@export var is_skippable: bool = true

@onready var _lbl : RichTextLabel = $Label 

@export var _fade_in_duration : float = 1.0
@export var _fade_out_duration : float = 1.0
@export var _print_while_fading_in : bool = false


var _is_faded_out: bool:
	get: return (not self.visible) or (self.modulate.a == 0)
var _og_modulate : Color

func _ready() -> void:
	_og_modulate = self.modulate
	if print_on_start: print_text(_lbl.text)

func _input(event: InputEvent) -> void:
	if is_skippable and event.is_action_pressed("SkipDialog"):
		finish_printing_immediately()

var _tw : Tween = null
var _on_finished : Callable
signal on_printing_finished()

func is_printing_in_progress()->bool:
	return _tw and _tw.is_running()

func finish_printing_immediately()->void:
		if _tw and _tw.is_running():
			_tw.stop()
			_tw = null
			_lbl.visible_characters = -1
			if _on_finished: _on_finished.call()
			_on_finished = Callable()
			on_printing_finished.emit()

func _process(delta: float) -> void:
	if not self.visible: return
	#print("visible chars: %d (%f)"%[_lbl.visible_characters, _lbl.visible_ratio])

const UNICODE_ZERO_WIDTH_SPACE = "\u200B"

func print_text(text:String, on_finished : Callable = Callable(), start_character_count: int = 0):
	if is_printing_in_progress():
		ErrorUtils.report_error("Printing new text while printing process is still running (old: '{0}', new: '{1}')".format([_lbl.text, text]))
		finish_printing_immediately()
	do_fade_the_finish_marker(0.0)
	if start_character_count > 0:
		while _lbl.visible_ratio >= 1.0:
			#print("ratio is %f"%_lbl.visible_ratio)
			_lbl.text = _lbl.text + UNICODE_ZERO_WIDTH_SPACE
			_lbl.visible_characters = start_character_count - 1
			await get_tree().process_frame
	#print("B.visible chars: %d (%f), start: %d"%[_lbl.visible_characters, _lbl.visible_ratio, start_character_count])
	_lbl.text = text + UNICODE_ZERO_WIDTH_SPACE
	_lbl.visible_characters = start_character_count
	if _is_faded_out:
		if _print_while_fading_in: do_fade_in()
		else: await do_fade_in()
	#print("A.visible chars: %d (%f), start: %d"%[_lbl.visible_characters, _lbl.visible_ratio, start_character_count])
	var total_chars := _lbl.get_total_character_count()
	assert(start_character_count <= total_chars, "Requesting start_character_count={0} when there are only {1} chars to print (text: '{2}')".format([start_character_count, total_chars, text]))
	_on_finished = on_finished
	_tw = create_tween()
	_tw.tween_method(func(i: int): 
		_lbl.visible_characters = i
		if randf() < char_sound_chance:
			SoundManager.PlaySound(sounds_per_char.pick_random(), randf_range(sound_pitch_range.x, sound_pitch_range.y))
	, start_character_count, total_chars, (total_chars-start_character_count) * seconds_per_char)
	await _tw.finished
	do_fade_the_finish_marker(1.0)
	_tw = null
	if _on_finished: _on_finished.call()
	on_printing_finished.emit()

func append_text(to_append: String, on_finished: Callable = Callable())->void:
	var new_text :String = _lbl.text + to_append
	var start_character_count :int = _lbl.get_total_character_count()
	print_text(new_text, on_finished, start_character_count)

func do_fade_in():
	if is_printing_in_progress():
		finish_printing_immediately()
	if not self.visible:
		self.modulate.a = 0.0
	self.visible = true
	self._tw = create_tween()
	_tw.tween_property(self, "modulate", _og_modulate, _fade_in_duration)
	await _tw.finished
	self._tw = null
	

func do_fade_out():
	if is_printing_in_progress():
		finish_printing_immediately()
	var target_modulate := self.modulate
	target_modulate.a = 0.0
	self._tw = create_tween()
	_tw.tween_property(self, "modulate", target_modulate, _fade_out_duration)
	await _tw.finished
	self._tw = null


@onready var _finish_marker_tween := EffectsUtils.TweenWrapper.new(self)
@export var _dot_fade_duration : float = 0.2
@onready var _finish_marker : CanvasItem = self.get_node_or_null("PrintFinishedMarker")
func do_fade_the_finish_marker(alpha: float)->void:
	if not _finish_marker: return
	print("FADING THE DOT: %f"%alpha)
	_finish_marker_tween.do_fade(_finish_marker, alpha, _dot_fade_duration)
	
	
