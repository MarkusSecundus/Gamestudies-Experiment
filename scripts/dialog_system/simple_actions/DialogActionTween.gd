extends IDialogAction

@export var target : Node
@export var property : StringName
@export var start_value : Variant
@export var end_value : Variant
@export var duration : float
@export var ease : Tween.EaseType = Tween.EaseType.EASE_IN_OUT
@export var transition : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR
@export_group("Advanced")
@export var start_visibility : SetVisibilityMode = SetVisibilityMode.DoNothing
@export var end_visibility : SetVisibilityMode = SetVisibilityMode.DoNothing
@export var wait_for_finish : bool = true

enum SetVisibilityMode{
	DoNothing, SetShown, SetHidden, Flip
}

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	if start_value != null:
		target.set(property, start_value)
	_set_visibility_helper(target as CanvasItem, start_visibility)
	var tw := create_tween()
	var tweener := tw.tween_property(target, NodePath(property), end_value, duration)
	tweener.set_ease(ease)
	tweener.set_trans(transition)
	
	if (target is CanvasItem) and end_visibility != SetVisibilityMode.DoNothing:
		CoroutineUtils.run_on_signal_once(tweener.finish, func()->void: _set_visibility_helper(target as CanvasItem, end_visibility))
	if wait_for_finish: 
		await tweener.finished
	_default_perform(ctx, on_finished)

static func _set_visibility_helper(obj: CanvasItem, mode: SetVisibilityMode)->void:
	if (not obj) or (mode == SetVisibilityMode.DoNothing): return
	if mode == SetVisibilityMode.SetShown: obj.visible = true
	elif mode == SetVisibilityMode.SetHidden: obj.visible = false
	elif mode == SetVisibilityMode.Flip: obj.visible = (not obj.visible)
