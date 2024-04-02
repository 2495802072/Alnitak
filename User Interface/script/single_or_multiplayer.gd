extends BaseGUIView

@onready var Aflash1:AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var ui_manager:GUIViewManager = G._get_view_manager()

var had_hosted:bool = false 

func _ready():
	G.PLAY_MODE = G.PLAY_MODES.SINGLEPLAYER ##默认单人模式
	if G.has_multi_file():
		var file = ConfigFile.new()
		file.load(G.get_multi_file_path())
		if "host" in file.get_sections():
			had_hosted = true

func _open():
	Aflash1.play("RESET")

func _next_view():
	ui_manager.open_view("RoleSelect")
	_close_self()

func _open_host_scene():
	ui_manager.open_view("HostGame")
	_close_self()

func _open_join_scene():
	ui_manager.open_view("JoinGame")
	_close_self()

func _back_to_start_menu():
	ui_manager.open_view("StartMenu")
	_close_self()

func _on_multi_player_mouse_entered():
	$HBoxContainer/MultiPlayer.disabled = true
	Aflash1.play("show_button")
	if had_hosted: ##显示鼠标右击更改配置文件
		$HBoxContainer/MultiPlayer.text = "Reset By RightClick"


func _on_host_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed == true: ##限制为鼠标右键按下
			_open_host_scene()#跳转设置界面
	pass

func _on_host_pressed():
	G.PLAY_MODE = G.PLAY_MODES.MULTIPLAYER_HOST
	if had_hosted:
		_next_view()
	else:
		_open_host_scene()

func _on_join_pressed():
	G.PLAY_MODE = G.PLAY_MODES.MULTIPLAYER_JOIN
	_open_join_scene()
