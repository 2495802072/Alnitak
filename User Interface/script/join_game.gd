extends BaseGUIView

@onready var ip_line:LineEdit = $VBoxContainer/JoinIP/LineEdit as LineEdit

func _ready():
	if G.has_multi_file():
		var file = ConfigFile.new()
		var err:Error = file.load(G.get_multi_file_path())
		if err == OK: #确认正确载入
			for section in file.get_sections(): #遍历【节】
				if section == "join":
					ip_line.text = file.get_value(section,"ip")
		else:
			push_error("Failed to save config: %d" % err)
	pass

func _on_back_pressed():
	G._get_view_manager().open_view("SingleOrMultiplayer")
	_close_self()

func _on_enter_pressed():
	if write_to_file():
		G._get_view_manager().open_view("RoleSelect")
		_close_self()
	pass

func write_to_file() -> bool:
	var file = ConfigFile.new()
	var ip:String
	if ip_line.text != "":
		ip = ip_line.text
		file.set_value("join","ip",ip)
		var err:Error = file.save(G.get_multi_file_path()) # 成功保存即为OK
		if err != OK:
			push_error("Failed to save config: %d" % err)
		return true
	else:
		ip_line.grab_focus()
		return false
	
