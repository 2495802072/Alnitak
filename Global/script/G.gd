extends Node

var override_file:String = ProjectSettings.globalize_path("res://override.cfg")
var language_file:String = ProjectSettings.globalize_path("res://language.json")
var player_local_dir_path:String = ProjectSettings.globalize_path("user://Data/player/")
var world_local_dir_path:String = ProjectSettings.globalize_path("user://Data/world/")

func _enter_tree():
	if OS.has_feature("editor"):
		# 从编辑器二进制文件运行。
		override_file = ProjectSettings.globalize_path("res://override.cfg")
		language_file = ProjectSettings.globalize_path("res://language.json")
	else:
		# 从导出的项目运行。
		override_file = OS.get_executable_path().get_base_dir().path_join("override.cfg")
		language_file = OS.get_executable_path().get_base_dir().path_join("language.json")

func _ready():
	if FileAccess.file_exists(language_file):
		var strs = FileAccess.get_file_as_string(language_file)
		var json = JSON.new()
		var error = json.parse(strs)
		if error == OK:
			var data = json.data
			if typeof(data) == TYPE_DICTIONARY and data.has("language"):
				var lang = data["language"]
				_change_language(lang)
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", strs, " at line ", json.get_error_line())
		
	else:
		pass

func _get_game_root() -> Node:
	return get_node("/root/Game")

func _get_player_local_dir_path() -> String:
	return player_local_dir_path

func _get_world_local_dir_path() -> String:
	return world_local_dir_path

func _get_view_manager() -> GUIViewManager:
	var manager =  _get_game_root().get_node_or_null("%GUIViewManager")
	if manager:
		return manager
	else:
		print("can not find manager")
		return

func _save_game_settings():
	ProjectSettings.save_custom(override_file)
	pass

func _change_language(lang:String):
	if TranslationServer.get_locale() != lang:
		TranslationServer.set_locale(lang)

func _save_language(lang:String):
	var data = {
		"language":lang
	}
	var strs = JSON.stringify(data,"\t")
	var file = FileAccess.open(language_file,FileAccess.WRITE)
	file.store_string(strs)
	pass

func _get_role_manager() -> RoleManager:
	var manager =  _get_game_root().get_node_or_null("%RoleManager")
	if manager :
		return manager
	else:
		print("can not find manager")
		return

func _get_world_manager() -> WorldManager:
	var manager =  _get_game_root().get_node_or_null("%WorldManager")
	if manager :
		return manager
	else:
		print("can not find manager")
		return
