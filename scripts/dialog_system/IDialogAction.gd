class_name IDialogAction
extends SomeDialogContainer

@export var is_enabled : bool = true
@export var argument_overrides : Dictionary[String, String] = {}

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	_default_perform(ctx, on_finished)
	
func do_perform_with_argument_overrides(ctx: DialogContext, on_finished: Callable)->void:
	if argument_overrides.is_empty() or (not ctx.has_stack_frame()):
		do_perform(ctx, on_finished)
		return
	var function_args = ctx.peek_stack_frame().arguments
	var original_values : Dictionary[String, Variant] = {}
	for key :String in argument_overrides:
		var override_value :Variant = function_args[argument_overrides[key]]
		if override_value == null: continue
		var og_value :Variant= self.get(key)
		if override_value is NodePath and og_value is Node:
			override_value = get_node(override_value as NodePath) 
		original_values[key] = og_value
		self.set(StringName(key), override_value)
		
	if original_values.is_empty():
		do_perform(ctx, on_finished)
		return
		
	do_perform(ctx, func(n:Node)->void:
		for key in original_values: self.set(StringName(key), original_values[key])
		on_finished.call(n)	
	)

func _default_perform(_ctx: DialogContext, on_finished: Callable)->void:
	on_finished.call(null)

func _get_first_child()->IDialogAction:
	return NodeUtils.get_child_of_type(self, IDialogAction)

func run_dialog()->void:
	var system := NodeUtils.get_ancestor_of_type(self, DialogSystem) as DialogSystem
	assert(system)
	system.do_run(self)
