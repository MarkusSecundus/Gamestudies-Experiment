extends IDialogAction

@export var keys : Array[StringName]

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	while true:
		for key in keys:
			if Input.is_action_just_pressed(key):
				_default_perform(ctx, on_finished)
				return
		await get_tree().process_frame
