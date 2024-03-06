extends Node

var override_file:String = ProjectSettings.globalize_path("res://override.cfg")

func _ready():
	pass

func _get_game_root() -> Node:
	return get_node("/root/Game")

func _get_view_manager() -> GUIViewManager:
	var manager =  _get_game_root().get_node_or_null("%GUIViewManager")
	if manager:
		return manager
	else:
		print("can not find manager")
		return

func _save_game_setting():
	pass

func _load_game_setting():
	pass
