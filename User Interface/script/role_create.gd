extends BaseGUIView

signal cfg_be_changed() ## 玩家的config数据更改时产生信号
signal data_be_changed() ## 玩家的数值发生改变时发出

## 系统预设贴图路径
var role_list_path_local:String = ProjectSettings.globalize_path("res://Asset/PlayerResource/configs/")

## 角色保存路径
@onready var role_save_local_path:String = G._get_player_local_dir_path()
@onready var difficult_button:OptionButton = %Difficultes
@onready var player_name_textbox:LineEdit = %PlayerName
@onready var number_box:GridContainer = $VBoxContainer/HSplitContainer/VSplitContainer/HSplitContainer/NumericalValueBox

var data:PlayerData

func _ready():
	dir_contents(role_list_path_local)
	
	data = PlayerData.new() ## 每次打开该页面只能创建一个角色
	pass

## 页面初始化过程
func dir_contents(path): ##遍历path文件夹,获取预设贴图
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("发现目录：" + file_name)
				pass
			else:
				add_item_to_list(role_list_path_local+file_name)
			file_name = dir.get_next()
	else:
		print("尝试访问路径时出错。")

func add_item_to_list(file_name:String) -> void: ## 把文件夹内的文件按着特定的模式添加到RoleList
	var rbutton:ResourceButton = ResourceButton.new()
	rbutton.resource = ResourceLoader.load(file_name,"ChartletConfig")
	rbutton.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	rbutton._sand_resouce.connect(set_player_config.bind())
	%RoleList.add_child(rbutton)
	pass

func initialize_player_data(): ## 与cfg_be_changed信号直接连接,给新建立的角色data赋予初值
	data.HP_base = data.config.HP_base
	data.HP_buff = data.config.HP_buff
	data.MP_base = data.config.MP_base
	data.ATK_base = data.config.ATK_base
	data.ATK_buff = data.config.ATK_buff
	data.DEF_base = data.config.DEF_base
	data.DEF_buff = data.config.DEF_buff
	data_be_changed.emit()

func update_ui(): ## 与cfg_be_changed信号直接连接,主要用于修改控件的disable属性以及数值的显示
	if data.config.resource_name == "GameEngineer": ##特殊角色
		difficult_button.select(0)
		difficult_button.disabled = true
		for item:Node in number_box.get_children():
			if item is LineEdit:
				pass
	else:
		difficult_button.disabled = false
	

## 以下是玩家建立过程
func set_player_name(s:String) -> void: ##按下Enter设置玩家名称
	data.player_name = s
	data.resource_name = s
	$VBoxContainer/HSplitContainer2/Create.grab_focus()

func text_focus_exited(): ## 文本框失焦设置玩家名称
	set_player_name(player_name_textbox.text)

func add_to_player_bag(item) -> void: ## 添加物品至玩家物品栏
	pass

func set_player_config(cfg:ChartletConfig) -> void:
	data.config = cfg
	cfg_be_changed.emit()

## UI操作
func _on_create_pressed() -> void:
	if DirAccess.dir_exists_absolute(role_save_local_path): 
		if data.player_name != "":
			data.save_player()
			_turn_back()
		else:
			player_name_textbox.grab_focus()
	else:
		print("访问文件目录丢失，尝试重新建立文件夹目录")
		var dir = DirAccess.open("user://")
		if dir.make_dir_recursive(role_save_local_path) == OK:
			_on_create_pressed()

func _turn_back() -> void:
	G._get_view_manager().open_view("RoleSelect")
	##此处视情况有可能需要queue玩家数据
	_close_self()
