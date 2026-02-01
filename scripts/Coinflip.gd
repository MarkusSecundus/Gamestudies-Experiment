extends Node

var id : String
var is_game : bool

var chosen_parent : Node2D:
	get: return $GameFirst if is_game else $QuestionnaireFirst

func _ready() -> void:
	id = load_random_id().strip_edges()
	is_game = load_is_game_first()
	$QuestionnaireFirst.visible = false
	$GameFirst.visible = false
	chosen_parent.visible = true
	var lbl = chosen_parent.get_node("Label")
	lbl.text = lbl.text.format([id])
	EyePiedestal.write_record({"type": "user_id", "id": id})


func load_random_id()->String:
	return get_persistent("user://test_subject_name.txt", generate_random_id)
	
func load_is_game_first()->bool:
	var str := get_persistent("user://cointoss.txt", randi)
	var num := int(str)
	return (num & 2)

func generate_random_id()->int:
	return ResourceUID.create_id() + randi()

func copy_id_to_clipboard()->void:
	DisplayServer.clipboard_set(id)
	_display_user_id()

func _display_user_id() -> void:
	# Web browsers restrict clipboard access, so we use a prompt instead
	var js_code := """
		prompt("Your ID", "{0}");
	""".format([id])
	var clipboard : Variant = JavaScriptBridge.eval(js_code, true)
	if clipboard == null or clipboard == "":
		return  # User cancelled or provided empty input
	# ...
	# ... do something with the clipboard data

static func get_persistent(path : String, supplier : Callable)->String:
	var fread := FileAccess.open(path, FileAccess.READ)
	if fread && fread.is_open():
		var ret := fread.get_as_text()
		fread.close()
		return ret
	
	var ret := "%s"%supplier.call()
	var fwrite := FileAccess.open(path, FileAccess.WRITE)
	if fwrite and fwrite.is_open():
		fwrite.store_line(ret)
		fwrite.flush()
		fwrite.close()
	return ret
