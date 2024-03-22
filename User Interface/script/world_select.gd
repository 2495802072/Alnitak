extends BaseGUIView
@onready var worldFile_path_local:String = G._get_world_local_dir_path()
@onready var information:Control = $VSplitContainer/HSplitContainer/DetailedInformation as Control

func _ready():
	information.hide() ##详细信息默认保持隐藏，选中世界后展开
	_dir_contents(worldFile_path_local)

func _change_view_to_create_world() -> void: ##按钮信号触发
	G._get_view_manager().open_view("WorldCreate")
	_close_self()

func _on_back_pressed() -> void:
	G._get_view_manager().open_view("PlayerSelect")
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

func _add_item_to_list(path:String) -> void: ## 给worldList添加内容
	pass
