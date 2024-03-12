extends BaseGUIView

func _open():
	_hide_others()

func _close():
	_show_others()


func _on_back_pressed():
	G._get_view_manager().open_view("StartMenu")
	_close_self()
