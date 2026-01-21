class_name DialogAction_Fader
extends IDialogAction

@export var target : CanvasItem
@export var target_fader : DialogAction_Fader

@export var start_alpha : float
@export var end_alpha : float
@export var duration_seconds : float
@export var ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var wait_for_finish : bool = true

var _tw : EffectsUtils.TweenWrapper:
	get:
		if not _tw:
			if target_fader: _tw = target_fader._tw
			else: _tw = EffectsUtils.TweenWrapper.new(target if target else FaderSingleton.INSTANCE) 
		return _tw
			
func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var tw := _tw.create_tween()
	var fader : CanvasItem = _tw.obj
	fader.visible = true
	var final_color = fader.modulate
	final_color.a = end_alpha
	if start_alpha >= 0.0: fader.modulate.a = start_alpha
	var tweener := tw.tween_property(fader, "modulate", final_color, duration_seconds)
	tweener.set_ease(ease)
	tweener.set_trans(transition)
	if wait_for_finish:
		await tw.finished
	
	_default_perform(ctx, on_finished)
