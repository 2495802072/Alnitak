class_name WorldData extends Resource

@export var world_name:String
@export var world_time:int ##统计地图游戏时长
@export var difficult := DIFFICULTIES.EASY
#@export var chunks:Dictionary = {}
@export var world_seed:int
@export var tile_set:TileSet = preload("res://Asset/WorldResource/TileSet/Blocks2.tres")
@export var chunk_size:int = 16

@export var enemy_list:Array ## TODO
@export var player_borth_position:Vector2i = Vector2i(7,7) ##玩家出生点

@export var player_position:Dictionary

enum DIFFICULTIES{
	EASY,NORMAL,DIFFICULT
}

func save_as_world() -> void: ## 文件另存为，更改文件名时使用，一般情况可以直接使用["NPC/script/player.gd"]的 _save_file() 方法
	var dir:String = G._get_world_local_dir_path()
	var file_name:String = resource_name + ".tres"
	ResourceSaver.save(self,dir+file_name)

func _rename() -> void:
	pass
