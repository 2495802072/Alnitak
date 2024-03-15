extends BaseGUIView

@onready var role_list = %RoleList as HBoxContainer

func _ready():
	pass

func _open():
	_hide_others()

func _close():
	_show_others()

func _on_back_pressed():
	G._get_view_manager().open_view("StartMenu")
	_close_self()

func change_view_to_create_player():
	G._get_view_manager().open_view("RoleCreate")
	_close_self()
	pass
