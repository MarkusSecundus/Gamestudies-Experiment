class_name GameManager
extends Node

@export var question_box : PrettyTextBox

@export_file("*.txt") var _questions_path : String

#@onready var _questions := _load_questions(_questions_path)
var _questions : PackedStringArray = ["Lorem ipsum dolor sit amet.\nConsectetuer adipiscing elit.."]

var _active_question_idx : int = -1

static var INSTANCE : GameManager = null

func _ready() -> void:
	if INSTANCE:
		ErrorUtils.report_error("Creating another GameManager ({0}) when one already exists ({1})".format([self, INSTANCE]))
	INSTANCE = self
	next_question()

		

func next_question()->void:
	_active_question_idx += 1
	if _active_question_idx >= _questions.size():
		_active_question_idx = 0
	question_box.print_text(_questions[_active_question_idx])



func record_answers(answer:Answer)->void:
	const ANSWERS_PATH = "answers.txt"
	answer.question_idx = _active_question_idx
	answer.question_text = _questions[_active_question_idx]
	var to_append := JSON.stringify(answer.serialize(), "\t")
	var f := FileAccess.open(ANSWERS_PATH, FileAccess.READ_WRITE)
	if not f: f = FileAccess.open(ANSWERS_PATH, FileAccess.WRITE)
	f.seek_end()
	f.store_line(to_append)
	f.close()

static func _load_questions(path: String)->PackedStringArray:
	var ret : PackedStringArray = []
	var current : String = ""
	var f := FileAccess.open(path, FileAccess.READ)
	
	while not f.eof_reached():
		var line := f.get_line()
		if line.length() > 0 and line[0] == "-": 
			if not current.strip_edges().is_empty():
				ret.append(current)
				current = ""
		else:
			current += "\n" + line
	if not current.strip_edges().is_empty():
		ret.append(current)
		current = ""
		
	f.close()
	return ret
