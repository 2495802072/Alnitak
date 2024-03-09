extends HSlider

func _ready():
	value = ProjectSettings.get_setting("gui/theme/default_theme_scale")


func _on_drag_ended(_value_changed:bool):
	ProjectSettings.set_setting("gui/theme/default_theme_scale",value)
