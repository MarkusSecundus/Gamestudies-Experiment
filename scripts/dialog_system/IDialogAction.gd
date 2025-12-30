class_name IDialogAction
extends SomeDialogContainer

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	_default_perform(ctx, on_finished)


func _default_perform(_ctx: DialogContext, on_finished: Callable)->void:
	on_finished.call(null)
