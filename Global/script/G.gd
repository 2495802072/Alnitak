extends Node

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
