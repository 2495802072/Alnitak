extends Node

var override_file:String = ProjectSettings.globalize_path("res://override.cfg")
var language_file:String = ProjectSettings.globalize_path("res://language.json")

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
		_save_language(lang)

func _save_language(lang:String):
	var data = {
		"language":lang
	}
	var strs = JSON.stringify(data,"\t")
	var file = FileAccess.open(language_file,FileAccess.WRITE)
	file.store_string(strs)
	pass
