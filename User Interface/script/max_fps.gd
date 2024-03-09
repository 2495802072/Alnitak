extends SpinBox


func _ready():
	value = ProjectSettings.get_setting("application/run/max_fps")
	if value == 0:
		suffix = "(FPS not limit)"
	else:
		suffix = ""

func _on_value_changed(_value:float):
	ProjectSettings.set_setting("application/run/max_fps",_value)
	if _value == 0:
		suffix = "(FPS not limit)"
	else:
		suffix = ""
