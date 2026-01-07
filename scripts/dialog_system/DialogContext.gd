class_name DialogContext
extends RefCounted

class StackFrame:
	var caller: IDialogAction
	var arguments : Dictionary[String, Variant]

	func _init(the_caller: IDialogAction, the_arguments : Dictionary[String, Variant]) -> void:
		self.caller = the_caller
		self.arguments = the_arguments

var _temporary_variables : Dictionary[String, Variant] = {}
var _call_stack : Array[StackFrame] = []

var default_text_box : PrettyTextBox
var _dialog_system : DialogSystem

func has_stack_frame()->bool: return not _call_stack.is_empty()

func push_stack_frame(caller: IDialogAction, arguments : Dictionary[String, Variant])->StackFrame:
	var ret := StackFrame.new(caller, arguments)
	_call_stack.append(ret)
	return ret
	
func pop_stack_frame()->StackFrame:
	if _call_stack.is_empty(): return null
	var ret := _call_stack[_call_stack.size() - 1]
	_call_stack.remove_at(_call_stack.size()-1)
	return ret

func peek_stack_frame()->StackFrame:
	if _call_stack.is_empty(): return null
	return _call_stack[_call_stack.size()-1]
