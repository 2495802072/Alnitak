@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/project_plug/project_node.tscn").instantiate()
	add_control_to_dock(2,dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
