extends IDialogAction


signal the_signal()


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	the_signal.emit()
	_default_perform(ctx, on_finished)
