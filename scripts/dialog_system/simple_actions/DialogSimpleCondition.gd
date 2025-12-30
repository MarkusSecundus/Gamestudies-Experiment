class_name DialogSimpleCondition
extends IDialogAction

@export var condition_holds : bool = true


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	if condition_holds:
		var child := NodeUtils.get_child_of_type(self, IDialogAction) as IDialogAction
		assert(child)
		on_finished.call(child)
	else: 
		_default_perform(ctx, on_finished)
