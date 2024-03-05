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
	var node = ClassDB.instantiate("HSplitContainer")
	node.layout_mode = 1
	node.set_anchors_preset(PRESET_TOP_WIDE)
	node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.collapsed = true
	var label = ClassDB.instantiate("Label")
	label.text = "条目2"
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var check_button = ClassDB.instantiate("CheckButton")
	check_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	node.add_child(label,true)
	node.add_child(check_button,true)
	return node
