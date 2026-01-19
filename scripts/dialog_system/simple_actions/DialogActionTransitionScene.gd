extends IDialogAction

@export var destination : PackedScene

func do_perform(_ctx: DialogContext, on_finished: Callable)->void:
	get_tree().change_scene_to_packed(destination)
