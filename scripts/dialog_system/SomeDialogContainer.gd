@tool
class_name SomeDialogContainer
extends Node

@export_tool_button("Add Message") var _add_message_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogMessage, "Text")
@export_tool_button("Add Jump") var _add_jump_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogJump, "Jump")
@export_tool_button("Add Simple Condition") var _add_simple_condition_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogSimpleCondition, "Condition")
@export_tool_button("Add Coroutine") var _add_coroutine_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogCoroutine, "Coroutine")
@export_tool_button("Add Call") var _add_call_btn = func()->void:NodeUtils.instantiate_child_by_type_and_select(self, DialogCall, "Call")
