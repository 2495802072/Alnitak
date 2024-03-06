extends BaseGUIView

func _open():
	_hide_others()
	pass

func _close():
	_show_others()
	pass


func _on_back_pressed():
	G._save_game_settings()
	_close_self()
