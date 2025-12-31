@tool
class_name DialogCoroutine
extends IDialogAction

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	on_finished.call(_get_first_child())
