class_name VisualEffectProvider
extends Node

@export var target : CanvasItem
@onready var _actual_target : CanvasItem = target if target else ((self as Node) as CanvasItem)

@export_group("Fading")
@export var fade_in_duration_seconds : float = 1.0
@export var fade_out_duration_seconds : float = 1.0
@export var fade_in_ease : Tween.EaseType = Tween.EaseType.EASE_IN
@export var fade_out_ease : Tween.EaseType = Tween.EaseType.EASE_OUT
@export var fade_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

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


@export_group("Zooming")
@export var zoom_in_duration_seconds : float = 0.3
@export var zoom_out_duration_seconds : float = 0.3
@export var zoom_in_ease : Tween.EaseType = Tween.EaseType.EASE_IN
@export var zoom_out_ease : Tween.EaseType = Tween.EaseType.EASE_OUT
@export var zoom_transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var zoom_multiplier : Vector2 = Vector2.ONE

@onready var _og_scale :Vector2 = _actual_target.get("scale")
@onready var _scale_tw := EffectsUtils.TweenWrapper.new(self)

func do_zoom_in()->void:
	var target_scale := GeometryUtils.multiply_memberwise2(_og_scale, zoom_multiplier)
	var tw := _scale_tw.create_tween().tween_property(_actual_target, "scale", target_scale, zoom_in_duration_seconds)
	tw.set_ease(zoom_in_ease)
	tw.set_trans(zoom_transition)

func do_zoom_out()->void:
	var tw := _scale_tw.create_tween().tween_property(_actual_target, "scale", _og_scale, zoom_out_duration_seconds)
	tw.set_ease(zoom_out_ease)
	tw.set_trans(zoom_transition)
