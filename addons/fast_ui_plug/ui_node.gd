@tool
extends EditorPlugin

var dock

func _enter_tree():
	dock = preload("res://addons/fast_ui_plug/ui_dock.tscn").instantiate()
	add_control_to_dock(3,dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
 
