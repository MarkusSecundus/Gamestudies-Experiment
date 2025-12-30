extends IDialogAction

@export var delay_seconds : float = 0.0

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	await get_tree().create_timer(delay_seconds).timeout
	_default_perform(ctx, on_finished)
