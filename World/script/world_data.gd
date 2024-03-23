class_name WorldData extends Resource

@export var world_name:String
@export var world_time:int ##统计地图游戏时长
@export var difficult := DIFFICULTIES.EASY
@export var block:Array[AreaBlock]
@export var world_seed:int
@export var tile_set:TileSet = preload("res://Asset/WorldResource/TileSet/Blocks1.tres")

@export var enemy_list:Array

enum DIFFICULTIES{
	EASY,NORMAL,DIFFICULT
}

func save_as_world() -> void: ## 文件另存为，更改文件名时使用，一般情况可以直接使用["NPC/script/player.gd"]的 _save_file() 方法
	var dir:String = G._get_world_local_dir_path()
	var file_name:String = resource_name + ".tres"
	ResourceSaver.save(self,dir+file_name)

func _rename() -> void:
	pass
