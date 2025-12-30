@tool
class_name SomeDialogContainer
extends Node

@export_tool_button("Add Message") var _add_message_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogMessage, "Text")
@export_tool_button("Add Jump") var _add_jump_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogJump, "Jump")
@export_tool_button("Add Simple Condition") var _add_simple_condition_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogSimpleCondition, "Condition")
