extends IDialogAction

@export var target : Node
@export var property : StringName
@export var start_value : Variant
@export var end_value : Variant
@export var duration : float
@export var ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	if start_value != null:
		target.set(property, start_value)
	var tw := create_tween()
	var tweener := tw.tween_property(target, NodePath(property), end_value, duration)
	tweener.set_ease(ease)
	tweener.set_trans(transition)
	await tweener.finished
	_default_perform(ctx, on_finished)
