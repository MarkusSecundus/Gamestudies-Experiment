extends IDialogAction

@export var prototype : PackedScene
@export var parent : Node
@export var attribute_overrides : Dictionary[StringName, Variant]
@export var actions_to_call : PackedStringArray

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var instance := prototype.instantiate()
	parent.add_child(instance)
	for attr_override in attribute_overrides:
		instance.set(attr_override, attribute_overrides[attr_override])
	
	_default_perform(ctx, on_finished)
	
