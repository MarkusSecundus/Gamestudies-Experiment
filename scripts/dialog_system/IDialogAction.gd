class_name IDialogAction
extends SomeDialogContainer

@export var is_enabled : bool = true

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	_default_perform(ctx, on_finished)

func _default_perform(_ctx: DialogContext, on_finished: Callable)->void:
	on_finished.call(null)

func _get_first_child()->IDialogAction:
	return NodeUtils.get_child_of_type(self, IDialogAction)
