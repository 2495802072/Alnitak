extends BaseGUIView

@onready var ip_line:LineEdit = $VBoxContainer/Panel/VBoxContainer/IP/LineEdit as LineEdit
@onready var port_line:LineEdit = $VBoxContainer/Panel/VBoxContainer/Port/LineEdit as LineEdit
@onready var max_player:LineEdit = $VBoxContainer/Panel/VBoxContainer/MaxPlayer/LineEdit as LineEdit

func _ready():
	if G.has_multi_file():
		var file = ConfigFile.new()
		var err:Error = file.load(G.get_multi_file_path())
		if err == OK: #确认正确载入
			for section in file.get_sections(): #遍历【节】
				if section == "host":
					ip_line.text = file.get_value(section,"ip")
					port_line.text = file.get_value(section,"port")
		else:
			push_error("Failed to save config: %d" % err)
	pass

func _on_back_pressed():
	G._get_view_manager().open_view("SingleOrMultiplayer")
	_close_self()

func _on_enter_pressed():
	write_to_file()
	G._get_view_manager().open_view("RoleSelect")
	_close_self()

func write_to_file():
	var file = ConfigFile.new()
	var ip:String = ip_line.placeholder_text
	var port:String = port_line.placeholder_text
	var player_num:String = max_player.placeholder_text
	if ip_line.text != "":
		ip = ip_line.text
	if port_line.text != "":
		port = port_line.text
	if max_player.text != "":
		player_num = max_player.text
	file.set_value("host","ip",ip)
	file.set_value("host","port",port)
	file.set_value("host","max_player",player_num)
	var err:Error = file.save(G.get_multi_file_path()) # 成功保存即为OK
	if err != OK:
		push_error("Failed to save config: %d" % err)
