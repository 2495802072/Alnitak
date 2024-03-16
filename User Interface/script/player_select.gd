extends BaseGUIView

@onready var role_list:HBoxContainer = %RoleList as HBoxContainer
@onready var players_path:String = G._get_player_local_dir_path()

func _ready():
	dir_contents(players_path)

func _open():
	_hide_others()

func _close():
	_show_others()

func _on_back_pressed():
	G._get_view_manager().open_view("StartMenu")
	_close_self()

func change_view_to_create_player():
	G._get_view_manager().open_view("RoleCreate")
	_close_self()

func next_view():
	pass

func dir_contents(path): ##遍历path文件夹,获取预设贴图
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				add_item_to_list(players_path+file_name)
			file_name = dir.get_next()
	else:
		printerr("尝试访问PlayerData路径时出错。")

func add_item_to_list(file_name:String) -> void: ## 把文件夹内的文件添加到PlayerList
	var rbutton:ResourceButton = ResourceButton.new()
	rbutton.resource = ResourceLoader.load(file_name,"PlayerData")
	rbutton.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	rbutton.custom_minimum_size = Vector2(250,250)
	rbutton._sand_resouce.connect(selected.bind())
	role_list.add_child(rbutton)
	pass

func selected(player:Resource):
	pass
