@tool
extends Button

var sel:EditorSelection = EditorInterface.get_selection()
var main_box= preload("res://addons/fast_ui_plug/primary page/main_box.tscn").instantiate()


func _pressed():
	var selection = sel.get_selected_nodes()[0] #获取选中第一个对象
	selection.add_child(main_box)
	main_box.owner = EditorInterface.get_edited_scene_root()
	pass
