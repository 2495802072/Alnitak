@tool
extends HSplitContainer

var dictionary = {
	"ignore":0,
	"keep":1,
	"keep_width":2,
	"keep_height":3,
	"expand":4
}

func _enter_tree():
	ProjectSettings.settings_changed.connect(_ready.bind())
	pass

func _ready():
	var mode:String
	mode = ProjectSettings.get_setting("display/window/stretch/aspect","null")
	$OptionButton.select(dictionary[mode])
	pass

func selected(index:int):
	var mode:String
	mode = dictionary.find_key(index)
	ProjectSettings.set_setting("display/window/stretch/aspect",mode)
	pass
