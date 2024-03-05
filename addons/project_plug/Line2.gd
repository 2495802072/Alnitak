@tool
extends HSplitContainer

var dictionary = {
	"disabled":0,
	"canvas_items":1,
	"viewport":2
}

func _enter_tree():
	ProjectSettings.settings_changed.connect(_ready.bind())
	pass

func _ready():
	var mode:String
	mode = ProjectSettings.get_setting("display/window/stretch/mode","null")
	$OptionButton.select(dictionary[mode])
	pass 

func selected(index:int):
	var mode:String
	mode = dictionary.find_key(index)
	ProjectSettings.set_setting("display/window/stretch/mode",mode)
	pass
