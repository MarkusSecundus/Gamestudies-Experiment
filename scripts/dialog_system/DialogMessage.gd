@tool
class_name DialogMessage
extends IDialogAction

@export var wait_for_user_input : bool = true
@export_multiline var text : String
@export var append: bool = false
@export var text_box_override : PrettyTextBox = null
@export var do_fade_out_after : bool = false

@export_tool_button("Preview") var _preview_tool_btn = func():
	var text_box := text_box_override if text_box_override else (NodeUtils.get_ancestor_of_type(self, DialogSystem, NodeUtils.LOOKUP_FLAGS.INCLUDE_INTERNAL) as DialogSystem).default_text_box
	var previewable := NodeUtils.get_descendant_of_type(text_box, LabelVisualizeTextPiece) as LabelVisualizeTextPiece
	if previewable: 
		previewable.source = self

func do_perform(ctx: DialogContext, on_finished: Callable)->void:
	var text_box := text_box_override if text_box_override else ctx.default_text_box
	var on_printing_finished: Callable = func():
		if wait_for_user_input:
			print("{0} - awaiting user input...".format([self.name]))
			await get_tree().create_timer(0.2).timeout
			while true:
				await get_tree().process_frame
				if Input.is_action_just_pressed("SkipDialog"):
					print("got an input event")
					break
		if do_fade_out_after:
			await text_box.do_fade_out()
		_default_perform(ctx, on_finished)
	if append: text_box.append_text(text, on_printing_finished, wait_for_user_input)
	else: text_box.print_text(text, on_printing_finished, wait_for_user_input)
	
	
