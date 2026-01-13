extends IDialogAction

@export var target : CanvasItem

@export var start_alpha : float
@export var end_alpha : float
@export var duration_seconds : float
@export var ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export var wait_for_finish : bool = true

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var tw := create_tween()
	var fader : CanvasItem = target if target else FaderSingleton.INSTANCE
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
