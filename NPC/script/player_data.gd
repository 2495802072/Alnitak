class_name PlayerData extends RoleBase

@export var clan = RoleBase.CLAN.PLAYER ##默认设定类型为[玩家],详情->[enum RoleBase.CLAN]
@export var player_name:String ## 玩家昵称,同时决定了玩家保存数据时的文件名称

@export var bag_size:int = 10 ##玩家背包大小
@export var player_bag:Array[int] ##存储玩家背包数据

func save_player():
	var dir:String = G._get_player_local_dir_path()
	var file_name:String = resource_name + ".tres"
	ResourceSaver.save(self,dir+file_name)
