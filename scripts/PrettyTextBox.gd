class_name PrettyTextBox
extends Node


@export var seconds_per_char := 0.05
@export_range(0.0, 1.0) var char_sound_chance = 0.03 
@export var sounds_per_char : Array[AudioStream]
@export var sound_pitch_range := Vector2(0.8, 0.9)

@onready var _lbl : RichTextLabel = $Label 

func _ready() -> void:
	print("ready question box")
	pass#print_text(_lbl.text)

func _input(event: InputEvent) -> void:
	if false and event.is_action_pressed("SkipDialog"):
		finish_printing_immediately()

var _tw : Tween = null
var _on_finished : Callable

func is_printing_in_progress()->bool:
	return _tw and _tw.is_running()

func finish_printing_immediately()->void:
		if _tw and _tw.is_running():
			_tw.stop()
			_tw = null
			_lbl.visible_characters = -1
			if _on_finished: _on_finished.call()

func print_text(text:String, on_finished : Callable = Callable())->void:
	_lbl.text = text
	_lbl.visible_characters = 0
	var total_chars := _lbl.get_total_character_count()
	if _tw and _tw.is_running(): _tw.stop()
	_on_finished = on_finished
	_tw = create_tween()
	_tw.tween_method(func(i: int): 
		_lbl.visible_characters = i
		if randf() < char_sound_chance:
			SoundManager.PlaySound(sounds_per_char.pick_random(), randf_range(sound_pitch_range.x, sound_pitch_range.y))
		if i == total_chars and _on_finished:
			_on_finished.call()
	, 0, total_chars, total_chars * seconds_per_char)
