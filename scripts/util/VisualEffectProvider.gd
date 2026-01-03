class_name VisualEffectProvider
extends Node

@export var target : CanvasItem

@export_group("Fading")
@export var fade_in_duration_seconds : float = 1.0
@export var fade_out_duration_seconds : float = 1.0
@export var fade_in_ease : Tween.EaseType = Tween.EaseType.EASE_IN
@export var fade_out_ease : Tween.EaseType = Tween.EaseType.EASE_OUT
@export var fade_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@onready var _actual_target : CanvasItem = target if target else ((self as Node) as CanvasItem)
@onready var _fade_tw : EffectsUtils.TweenWrapper = EffectsUtils.TweenWrapper.new(self)

@onready var _high_alpha = _actual_target.modulate.a if (_actual_target.modulate.a > 0.0) else 1.0
const _low_alpha = 0.0

func do_fade_in()->void:
	var tw := _fade_tw.do_fade(_actual_target, _high_alpha, fade_in_duration_seconds )
	tw.set_ease(fade_in_ease)
	tw.set_trans(fade_transition)

func do_fade_out()->void:
	var tw := _fade_tw.do_fade(_actual_target, _low_alpha, fade_in_duration_seconds )
	tw.set_ease(fade_out_ease)
	tw.set_trans(fade_transition)
