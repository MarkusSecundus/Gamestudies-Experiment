class_name PrettyTextBox
extends Node


@export var seconds_per_char := 0.05
@export var sounds_per_char : Array[AudioStream]

@onready var _lbl : RichTextLabel = $Label 

func _ready() -> void:
	print_text(_lbl.text)


var _tw : Tween = null

func print_text(text:String, on_finished : Callable = Callable())->void:
	_lbl.text = text
	_lbl.visible_characters = 0
	var total_chars := _lbl.get_total_character_count()
	if _tw and _tw.is_running(): _tw.stop()
	_tw = create_tween()
	_tw.tween_method(func(i: int): 
		_lbl.visible_characters = i
		if randf() > 0.97:
			SoundManager.PlaySound(sounds_per_char.pick_random(), randf_range(0.8, 0.9))
	, 0, total_chars, total_chars * seconds_per_char)
