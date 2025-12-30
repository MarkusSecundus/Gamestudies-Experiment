extends IDialogAction


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var piedestal := EyePiedestal.INSTANCE
	for part in piedestal._chosen_eye_parts.values():
		piedestal.remove_eye_part(part)
	_default_perform(ctx, on_finished)
