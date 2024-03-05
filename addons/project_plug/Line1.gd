@tool
extends HSplitContainer

func _enter_tree():
	ProjectSettings.settings_changed.connect(_ready.bind())
	pass

func _ready():
	var x = ProjectSettings.get_setting("display/window/size/viewport_width","null")
	var y = ProjectSettings.get_setting("display/window/size/viewport_height","null")
	$HSplitContainer/HSplitContainer/LineEdit.text = str(x)
	$HSplitContainer/HSplitContainer2/LineEdit.text = str(y)
	pass

func changed():
	var x:int = int($HSplitContainer/HSplitContainer/LineEdit.text)
	var y:int = int($HSplitContainer/HSplitContainer2/LineEdit.text)
	ProjectSettings.set_setting("display/window/size/viewport_width",x)
	ProjectSettings.set_setting("display/window/size/viewport_height",y)
	pass
