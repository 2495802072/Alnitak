extends BaseGUIView

var role_list_path_local:String = ProjectSettings.globalize_path("res://Asset/PlayerResource/configs/")

func _ready():
	print(role_list_path_local)
	dir_contents(role_list_path_local)
	pass

func dir_contents(path): ##遍历path文件夹
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("发现目录：" + file_name)
			else:
				print("发现文件：" + file_name)
			file_name = dir.get_next()
	else:
		print("尝试访问路径时出错。")

func add_item_to_list(file_name:String): ## 把文件夹内的文件按着特定的模式添加到RoleList
	var button:Button = Button.new()
	button.text = role_list_path_local+file_name
	
	button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	pass

func _turn_back():
	G._get_view_manager().open_view("RoleSelect")
	_close_self()

func _on_create_pressed():
	
	_turn_back()
