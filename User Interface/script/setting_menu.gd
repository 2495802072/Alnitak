extends BaseGUIView

func _open():
	_hide_others()
	pass

func _close():
	_show_others()
	pass


func _on_back_pressed():
	_close_self()
