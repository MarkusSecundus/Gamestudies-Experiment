class_name DialogContext
extends RefCounted

class StackFrame:
	var caller: IDialogAction

	func _init(the_caller: IDialogAction) -> void:
		self.caller = the_caller

var _temporary_variables : Dictionary[String, Variant] = {}
var _call_stack : Array[StackFrame] = []

var default_text_box : PrettyTextBox

func push_stack_frame(caller: IDialogAction)->StackFrame:
	var ret := StackFrame.new(caller)
	_call_stack.append(ret)
	return ret
	
func pop_stack_frame()->StackFrame:
	if _call_stack.is_empty(): return null
	var ret := _call_stack[_call_stack.size() - 1]
	_call_stack.remove_at(_call_stack.size()-1)
	return ret
