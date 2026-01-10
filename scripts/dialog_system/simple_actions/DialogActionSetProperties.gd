extends IDialogAction

@export var target : Node
@export var values : Dictionary[StringName, Variant]

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	for prop in values:
		target.set(prop, values[prop])
	_default_perform(ctx, on_finished)
	
