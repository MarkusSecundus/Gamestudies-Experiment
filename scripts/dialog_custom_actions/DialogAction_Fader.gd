extends IDialogAction

@export var start_alpha : float
@export var end_alpha : float
@export var duration_seconds : float
@export var ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var tw := create_tween()
	var fader : CanvasItem = FaderSingleton.INSTANCE
	fader.visible = true
	var final_color = fader.modulate
	final_color.a = end_alpha
	fader.modulate.a = start_alpha
	var tweener := tw.tween_property(fader, "modulate", final_color, duration_seconds)
	tweener.set_ease(ease)
	tweener.set_trans(transition)
	await tw.finished
	
	_default_perform(ctx, on_finished)
