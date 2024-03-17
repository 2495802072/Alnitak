extends BaseGUIView

@onready var role_list:HBoxContainer = %RoleList as HBoxContainer
@onready var players_path:String = G._get_player_local_dir_path()
@onready var enter_button:Button = $CenterContainer/HSplitContainer/Enter as Button
@onready var name_box:LineEdit = $PlayerNameBox as LineEdit
@onready var Aflash:AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var difficult:LineEdit = $HBoxContainer/Difficult as LineEdit
@onready var Health:LineEdit = $HBoxContainer/Health as LineEdit
@onready var Mana:LineEdit = $HBoxContainer/Mana as LineEdit
@onready var Bag:LineEdit = $HBoxContainer/Bag as LineEdit

var player_selected:PlayerData
var button_selected:ResourceButton

func _ready():
	enter_button.hide()
	dir_contents(players_path)
	
	player_selected = PlayerData.new()
	button_selected = ResourceButton.new()

func _open():
	pass

func _close():
	pass

func _on_back_pressed():
	G._get_view_manager().open_view("StartMenu")
	_close_self()

func change_view_to_create_player():
	G._get_view_manager().open_view("RoleCreate")
	_close_self()

func next_view():
	G._get_role_manager().create_player(player_selected)
	G._get_view_manager().open_view("StartMenu")
	_close_self()
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
		printerr("访问PlayerData路径时出错,尝试重新建立文件夹目录")
		dir = DirAccess.open("user://")
		if dir.make_dir_recursive(path) == OK:
			dir_contents(path)
		else:
			printerr("创建失败")

func add_item_to_list(file_name:String) -> void: ## 把文件夹内的文件添加到PlayerList
	var rbutton:ResourceButton = ResourceButton.new()
	rbutton.resource = ResourceLoader.load(file_name,"PlayerData")
	rbutton.set_h_size_flags(Control.SIZE_SHRINK_CENTER)
	rbutton.custom_minimum_size = Vector2(250,250)
	rbutton._sand_resouce.connect(selected.bind(rbutton))
	role_list.add_child(rbutton)

func selected(player:PlayerData,button:ResourceButton):
	player_selected = player
	button_selected = button
	name_box.text = player.player_name
	difficult.text = "Free"
	Health.text = str(player.HP_base)
	Mana.text = str(player.MP_base)
	Bag.text = str(player.bag_size)
	Aflash.play("RESET")
	Aflash.play("show_ui")
	enter_button.show()

func delete_player():
	var path:String = player_selected.resource_path
	DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	Aflash.play("RESET")
	role_list.remove_child(button_selected)
	_ready()
	pass
