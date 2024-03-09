extends OptionButton

var dic = {
	0:Window.MODE_WINDOWED,
	3:Window.MODE_FULLSCREEN,
	4:Window.MODE_EXCLUSIVE_FULLSCREEN
}

func _ready():
	var id:int = ProjectSettings.get_setting("display/window/size/mode")
	var index:int = get_item_index(id)
	select(index)
	pass

func _on_item_selected(_index:int):
	var id:int = get_item_id(_index)
	get_tree().root.mode = dic[id]
	ProjectSettings.set_setting("display/window/size/mode",id)
