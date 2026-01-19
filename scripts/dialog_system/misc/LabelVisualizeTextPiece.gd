@tool
class_name LabelVisualizeTextPiece
extends Control

@export var enabled : bool = true
@export var source: DialogMessage
@export var delimiter : String = ""

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint(): return
	if not enabled: return
	if not source: return
	if not visible: return
	do_visualize()

func do_visualize()->void:
	if not source: return
	var self_as_label := (self as Control) as Label
	var self_as_rich_text_label := (self as Control) as RichTextLabel
	if self_as_label:
		self_as_label.text = _get_all_text(source, delimiter)
	elif self_as_rich_text_label:
		self_as_rich_text_label.text = _get_all_text(source, delimiter)
	else:
		ErrorUtils.report_warning("LabelVisualizeTextPiece attached to a node `{0}` which is not a label!".format([NodeUtils.get_full_name(self)]))

static func _get_all_text(src: DialogMessage, separator :String)->String:
	var ret :String = ""
	ret += src.text
	var parent := src.get_parent()
	for idx in Vector2i(src.get_index() + 1, parent.get_child_count()):
		var next := parent.get_child(idx) as DialogMessage
		if not (next and next.is_enabled): continue
		if not next.append: break
		ret += separator
		ret += next.text
	return ret
