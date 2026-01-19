extends IDialogAction


@export var layer_index : int = 0


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	SoundManager.GetSoundtrackLayer(layer_index).play()
	_default_perform(ctx, on_finished)
