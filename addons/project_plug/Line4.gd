@tool
extends HSplitContainer

func _enter_tree():
	ProjectSettings.settings_changed.connect(_ready.bind())
	pass

func _ready():
	var mode = ProjectSettings.get_setting("application/config/use_custom_user_dir","null")
	$CheckBox.button_pressed = mode
	pass

func changed(mode:bool):
	ProjectSettings.set_setting("application/config/use_custom_user_dir",mode)
	pass
