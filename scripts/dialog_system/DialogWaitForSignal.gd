extends IDialogAction

@export var provider : SignalProvider

signal do_complete()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if provider: provider.the_signal.connect(do_complete.emit)
	do_complete.connect(func(): print("complete signal: {0}".format([self.name])))

func do_complete_func()->void:
	do_complete.emit()

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	await do_complete
	_default_perform(ctx, on_finished)
