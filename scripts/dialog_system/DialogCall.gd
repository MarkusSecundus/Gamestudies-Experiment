class_name DialogCall
extends IDialogAction

@export var callee : DialogCoroutine

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	ctx.push_stack_frame(self)
	on_finished.call(callee)
