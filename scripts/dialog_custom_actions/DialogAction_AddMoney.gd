extends IDialogAction

@export var amount : int

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	Economy.INSTANCE.add_money(amount);
	_default_perform(ctx, on_finished)
