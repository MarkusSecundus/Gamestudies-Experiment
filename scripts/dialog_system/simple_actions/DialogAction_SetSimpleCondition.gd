extends IDialogAction

@export var to_set : DialogSimpleCondition
@export var value_to_set :bool = true


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	to_set.condition_holds = value_to_set
	_default_perform(ctx, on_finished)
