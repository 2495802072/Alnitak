@tool
extends HSplitContainer

func _enter_tree():
	ProjectSettings.settings_changed.connect(_ready.bind())
	visible = ProjectSettings.get_setting("application/config/use_custom_user_dir",false)
	pass

func _ready():
	visible = ProjectSettings.get_setting("application/config/use_custom_user_dir",false)
	if visible and ProjectSettings.get_setting("application/config/custom_user_dir_name") == "":
		$LineEdit.text = ProjectSettings.get_setting("application/config/name","null")
	pass

func changed_name(new_name:String):
	ProjectSettings.set_setting("application/config/custom_user_dir_name",new_name)
	pass
