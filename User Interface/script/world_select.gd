extends BaseGUIView
@onready var worldFile_path_local:String = G._get_world_local_dir_path()
@onready var information:Control = $VSplitContainer/HSplitContainer/DetailedInformation as Control
@onready var world_list:VBoxContainer = $VSplitContainer/HSplitContainer/WorldList/WorldList as VBoxContainer
@onready var world_name_box:LineEdit = $VSplitContainer/HSplitContainer/DetailedInformation/VBoxContainer/WorldNameBox as LineEdit
@onready var seed_box:Label = $VSplitContainer/HSplitContainer/DetailedInformation/VBoxContainer/HSplitContainer/SeedBox as Label
@onready var difficult_box:Label = $VSplitContainer/HSplitContainer/DetailedInformation/VBoxContainer/HSplitContainer2/DifficultBox as Label
@onready var manager:WorldManager = G._get_world_manager() as WorldManager

var world_selected:WorldData
var button_selected:ResourceButton

func _open():
	_hide_others()
	pass

func _close():
	_show_others()
	pass

func _ready():
	information.hide() ##详细信息默认保持隐藏，选中世界后展开
	_dir_contents(worldFile_path_local)

func _change_view_to_create_world() -> void: ##按钮信号触发
	G._get_view_manager().open_view("WorldCreate")
	_close_self()

func _on_back_pressed() -> void: ##返回按钮
	G._get_world_manager().world_selected_over.emit()
	_close_self()

func _dir_contents(path:String) -> void: ##遍历path文件夹,获取资源
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name:String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				_add_item_to_list(worldFile_path_local+file_name)
			file_name = dir.get_next()
	else:
		printerr("访问WorldData路径时出错,尝试重新建立文件夹目录")
		dir = DirAccess.open("user://")
		if dir.make_dir_recursive(path) == OK:
			_dir_contents(path)
		else:
			printerr("创建失败")

func _add_item_to_list(file_name:String) -> void: ## 给worldList添加内容
	var rbutton:ResourceButton = ResourceButton.new()
	rbutton.resource = ResourceLoader.load(file_name,"WorldData") as WorldData
	rbutton.sand_resouce.connect(_selected.bind(rbutton))
	world_list.add_child(rbutton)

func _selected(world:WorldData,button:ResourceButton) -> void:
	world_selected = world
	button_selected = button
	if button.resource:
		world_name_box.text = button.get_resource_name()
		seed_box.text = str(world.world_seed)
		difficult_box.text = str(WorldData.DIFFICULTIES.find_key(world.difficult))
	information.show()
	pass

func _on_delete_pressed(): ##删除世界
	var path:String = world_selected.resource_path
	var f:bool = await G._get_view_manager().jump_alert("删除后无法恢复，是否确认删除？")
	if f: 
		if OS.has_feature("editor"): ## 判断是否是编辑器运行,移除文件
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
		else:
			DirAccess.remove_absolute(OS.get_executable_path().get_base_dir().path_join(path))
		_close_self() ## 自我重启
		G._get_view_manager().open_view("WorldSelect")
	pass

func _on_enter_pressed(): ##选择确认
	manager._init_data(world_selected)
	_close_self()
