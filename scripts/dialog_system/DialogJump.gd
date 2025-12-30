class_name DialogJump
extends IDialogAction
@export var destination : IDialogAction


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	on_finished.call(destination)
