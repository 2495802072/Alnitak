extends CheckButton

var mode:int
@onready var timer:Timer = $CoolingTime

func _ready():
	mode = ProjectSettings.get_setting("display/window/vsync/vsync_mode")
	if mode == 0:
		button_pressed = false
	else:
		button_pressed = true

func _on_toggled(toggled_on):
	if toggled_on:
		mode = 1
	else:
		mode = 0
	ProjectSettings.set_setting("display/window/vsync/vsync_mode",mode)
	DisplayServer.window_set_vsync_mode(mode)
	disabled = true
	$"../Label/Cooling".text = "Cooling"
	timer.start(1)

func _cooling_over():
	$"../Label/Cooling".text = ""
	disabled = false
	pass
