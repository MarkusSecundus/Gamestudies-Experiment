extends Node

func do_record(current_node: IDialogAction):
	EyePiedestal.write_record({"type" : "dialog_node_start", "node_path": NodeUtils.get_full_name(current_node, "/")})
