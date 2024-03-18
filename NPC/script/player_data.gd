class_name PlayerData extends RoleBase

@export var clan:int = RoleBase.CLAN.PLAYER ##默认设定类型为[玩家],详情->[enum RoleBase.CLAN]
@export var player_name:String ## 玩家昵称,同时决定了玩家保存数据时的文件名称

@export var bag_size:int = 10 ##玩家背包大小
@export var player_bag:Array[int] ##存储玩家背包数据
@export var difficult:int = RoleBase.DIFFICULT_PLAYER.EASY ##玩家难度

@export var player_position:Vector2 = Vector2.ZERO ##默认坐标(0,0)

func save_as_player() -> void: ## 文件另存为，更改文件名时使用，一般情况可以直接使用["NPC/script/player.gd"]的 _save_file() 方法
	var dir:String = G._get_player_local_dir_path()
	var file_name:String = resource_name + ".tres"
	ResourceSaver.save(self,dir+file_name)

func _rename() ->void:
	pass
