extends BaseGUIView

@onready var ip_line:LineEdit = $VBoxContainer/JoinIP/LineEdit as LineEdit
@onready var port_line:LineEdit = $VBoxContainer/JoinPort/LineEdit as LineEdit

func _ready():
	if G.has_multi_file():
		var file = ConfigFile.new()
		var err:Error = file.load(G.get_multi_file_path())
		if err == OK: #确认正确载入
			if "join" in file.get_sections(): #确认【节】存在
				ip_line.text = file.get_value("join","ip")
				port_line.text = file.get_value("join","port")
		else:
			push_error("Failed to save config: %d" % err)
	pass

func _on_back_pressed() -> void:
	G._get_view_manager().open_view("SingleOrMultiplayer")
	_close_self()

func _on_enter_pressed() -> void:
	G.PLAY_MODE = G.PLAY_MODES.MULTIPLAYER_JOIN
	if write_to_file():
		G._get_view_manager().open_view("RoleSelect")
		_close_self()
	pass

func write_to_file() -> bool:
	var file = ConfigFile.new()
	file.load(G.get_multi_file_path())
	var ip:String
	var port:String = port_line.placeholder_text
	if ip_line.text != "":
		ip = ip_line.text
		if port_line.text != "":
			port = port_line.text
		file.set_value("join","ip",ip)
		file.set_value("join","port",port)
		var err:Error = file.save(G.get_multi_file_path()) # 成功保存即为OK
		if err != OK:
			push_error("Failed to save config: %d" % err)
		return true
	else:
		ip_line.grab_focus()
		return false
	
