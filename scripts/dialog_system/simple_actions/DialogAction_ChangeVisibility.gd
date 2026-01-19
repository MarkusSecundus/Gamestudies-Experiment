extends IDialogAction

enum Mode{
	DoNothing, Enable, Disable, Switch
}

@export var targets : Array[CanvasItem]
@export var mode : Mode = Mode.DoNothing


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	for target in targets:
		if mode == Mode.Enable: target.visible = true
		if mode == Mode.Disable: target.visible = false
		if mode == Mode.Switch: target.visible = not target.visible
	_default_perform(ctx, on_finished)
