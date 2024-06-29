extends BaseGUIView

func _open():
	pass

func _close():
	pass

func _on_exit_pressed():
	get_tree().quit()

func _on_option_pressed():
	G._get_view_manager().open_view("SettingsMenu")

func _on_play_pressed():
	G._get_view_manager().open_view("SingleOrMultiplayer")
	_close_self()

func _on_button_mouse_entered():
	G._get_SFX_Player().Audio_Play(0,0.03)
