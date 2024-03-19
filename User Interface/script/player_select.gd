extends BaseGUIView

@onready var role_list:HBoxContainer = %RoleList as HBoxContainer
@onready var players_path:String = G._get_player_local_dir_path()
@onready var enter_button:Button = $CenterContainer/HSplitContainer/Enter as Button
@onready var name_box:LineEdit = $PlayerNameBox as LineEdit
@onready var Aflash1:AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var difficult:LineEdit = $HBoxContainer/Difficult as LineEdit
@onready var Health:LineEdit = $HBoxContainer/Health as LineEdit
@onready var Mana:LineEdit = $HBoxContainer/Mana as LineEdit
@onready var Bag:LineEdit = $HBoxContainer/Bag as LineEdit
@onready var role_manager:RoleManager = G._get_role_manager() as RoleManager

var player_selected:PlayerData
var button_selected:ResourceButton


func _ready():
	enter_button.hide()
	dir_contents(players_path)
	
	player_selected = PlayerData.new()
	button_selected = ResourceButton.new()

func _open():
	Aflash1.play("RESET")# 窗口变化会导致变形，最大化和全屏时退出会导致下一次启动出现尺寸超出屏幕的情况
	pass

func _close():
	Aflash1.play("RESET")
	pass

func _on_back_pressed():
	G._get_view_manager().open_view("SingleOrMultiplayer")
	_close_self()

func change_view_to_create_player():
	G._get_view_manager().open_view("RoleCreate")
	_close_self()

func _next_view():
	role_manager.create_player(player_selected)
	G._get_view_manager().open_view("StartMenu")
	_close_self()
	pass

func dir_contents(path:String): ##遍历path文件夹,获取预设贴图
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				add_item_to_list(players_path+file_name)
			file_name = dir.get_next()
	else:
		printerr("访问PlayerData路径时出错,尝试重新建立文件夹目录")
		dir = DirAccess.open("user://")
		if dir.make_dir_recursive(path) == OK:
			dir_contents(path)
		else:
			printerr("创建失败")

func add_item_to_list(file_name:String) -> void: ## 把文件夹内的文件添加到PlayerList
	var rbutton:ResourceButton = ResourceButton.new()
	rbutton.resource = ResourceLoader.load(file_name,"PlayerData") as PlayerData
	if not rbutton.get_resource_name() in role_manager.get_players_name_list():
		role_manager.add_player_name_to_list(rbutton.get_resource_name()) ## 添加已经使用的名字
	rbutton.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	rbutton.custom_minimum_size = Vector2(250,250)
	rbutton._sand_resouce.connect(selected.bind(rbutton))
	role_list.add_child(rbutton)

func selected(player:PlayerData,button:ResourceButton):
	player_selected = player
	button_selected = button
	name_box.text = player.player_name
	difficult.text = str(RoleBase.DIFFICULT_PLAYER.find_key(player.difficult))
	Health.text = str(player.HP_base)
	Mana.text = str(player.MP_base)
	Bag.text = str(player.bag_size)
	Aflash1.play("RESET")
	Aflash1.play("show_ui")
	enter_button.show()

func delete_player():
	var path:String = player_selected.resource_path
	## TODO 增加删除角色时 的确认步骤
	var f:bool = await G._get_view_manager().jump_alert("删除后无法恢复，是否确认删除？")
	if f: #确认删除
		if OS.has_feature("editor"):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
		else:
			DirAccess.remove_absolute(OS.get_executable_path().get_base_dir().path_join(path))
		role_manager.reset_players_name_list()
		# 重启当前页面
		_close_self()
		G._get_view_manager().open_view("RoleSelect")
	pass
