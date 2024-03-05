@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("BindButton","Button",preload("res://addons/custom_nodes/nodes/bind_button.gd"),preload("res://icon.svg"))
	pass

func _exit_tree():
	remove_custom_type("BindButton")
	pass
	
