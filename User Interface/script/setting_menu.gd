extends BaseGUIView

func _open():
	_hide_others()
	$HSplitContainer/Panel2/TabContainer.current_tab = 0
	$HSplitContainer/Panel2.hide()
	
	if not G._get_view_manager().has_language:
		_turn_to_language()

func _close():
	_show_others()
	pass

func _on_back_pressed():
	G._save_game_settings()
	G._save_language(TranslationServer.get_locale())
	_close_self()

func _turn_to_language():
	$HSplitContainer/Panel2/TabContainer.current_tab = 4

func buttom_hover_voice():
	G._get_SFX_Player().Audio_Play(0,0.03)

func selected() -> void:
	$HSplitContainer/Panel2.show()

