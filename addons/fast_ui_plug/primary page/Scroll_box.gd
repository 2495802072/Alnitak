@tool
extends Button

var sel:EditorSelection = EditorInterface.get_selection()

func _pressed():
	var selection = sel.get_selected_nodes()[0] #获取选中第一个对象
	var node = create_node()
	selection.add_child(node,true)
	for item in node.get_children():
		item.owner = EditorInterface.get_edited_scene_root()
	node.owner = EditorInterface.get_edited_scene_root()
	EditorInterface.edit_node(node)
	pass


func create_node():
	var node = ClassDB.instantiate("ScrollContainer")
	node.layout_mode = 1
	node.set_anchors_preset(PRESET_FULL_RECT)
	return node
