@tool
class_name DialogCall
extends IDialogAction

@export var callee : DialogCoroutine:
	get: return callee
	set(value):
		callee = value
		_enforce_arguments_invariants()
		
@export var arguments : Dictionary[String, Variant]:
	get: return arguments
	set(value):
		arguments = value
		_enforce_arguments_invariants()
			

func _enforce_arguments_invariants()->void:
		if callee and callee.arguments:
			DatastructUtils.ensure_these_and_only_these_dict_keys_are_present(arguments, callee.arguments, null)

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	for k in arguments.keys():
		var value :Variant= arguments[k]
		if value is NodePath:
			var node := get_node(value as NodePath)
			arguments[k] = node.get_path()
	ctx.push_stack_frame(self, arguments)
	on_finished.call(callee)
