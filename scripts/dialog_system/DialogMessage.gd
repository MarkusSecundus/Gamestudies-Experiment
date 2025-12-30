@tool
class_name DialogMessage
extends IDialogAction

@export var wait_for_user_input : bool = true
@export_multiline var text : String
@export var append: bool = false
@export var text_box_override : PrettyTextBox = null


func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var text_box := text_box_override if text_box_override else ctx.default_text_box
	var on_printing_finished: Callable = func():
		if wait_for_user_input:
			print("{0} - awaiting user input...".format([self.name]))
			while true:
				await get_tree().process_frame
				if Input.is_action_just_pressed("SkipDialog"):
					print("got an input event")
					break
		_default_perform(ctx, on_finished)
	if append: text_box.append_text("\n" + text, on_printing_finished)
	else: text_box.print_text(text, on_printing_finished)
	
	
