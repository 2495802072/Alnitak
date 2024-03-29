class_name WorldData extends Resource

@export var world_name:String
@export var world_time:int ##统计地图游戏时长
@export var difficult := DIFFICULTIES.EASY
@export var blocks_areas:Dictionary = {}
@export var world_seed:int
@export var tile_set:TileSet = preload("res://Asset/WorldResource/TileSet/Blocks2.tres")

@export var enemy_list:Array
@export var player_borth_position:Vector2i ##玩家出生点


enum DIFFICULTIES{
	EASY,NORMAL,DIFFICULT
}

func save_as_world() -> void: ## 文件另存为，更改文件名时使用，一般情况可以直接使用["NPC/script/player.gd"]的 _save_file() 方法
	var dir:String = G._get_world_local_dir_path()
	var file_name:String = resource_name + ".tres"
	ResourceSaver.save(self,dir+file_name)

func _rename() -> void:
	pass

func _get_blocks_array(area_id:Vector2i) -> Array[Vector2i]: ##返回区块内部的二维坐标数组
	var array:Array[Vector2i] = []
	var noise1:FastNoiseLite = FastNoiseLite.new()
	var noise2:FastNoiseLite = FastNoiseLite.new()
	noise1.set_seed(world_seed)
	noise2.set_seed(world_seed-1)
	for x in range(0,16):
		for y in range(0,16):
			var local_vector:Vector2i = area_id*16+Vector2i(x,y) ## 通过比较噪声的平方大小决定图格的去留
			if noise1.get_noise_2dv(local_vector)*noise1.get_noise_2dv(local_vector) < noise2.get_noise_2dv(local_vector)*noise2.get_noise_2dv(local_vector):
				array.append(local_vector)
	
	#区块生成后存回data
	var a:AreaBlock = AreaBlock.new()
	a.block_cells = array
	blocks_areas[area_id] = a ## 字典增加[Vector2i]:[AreaBlock]
	
	return array

func create_player_borth_position()-> void: ##生成玩家出生地
	var area_id = Vector2i.ZERO
	var array:Array[Vector2i] = []
	var noise1:FastNoiseLite = FastNoiseLite.new()
	var noise2:FastNoiseLite = FastNoiseLite.new()
	noise1.set_seed(world_seed)
	noise2.set_seed(world_seed-1)
	for x in range(0,16):
		for y in range(0,16):
			var local_vector:Vector2i = area_id*16+Vector2i(x,y) ## 通过比较噪声的平方大小决定图格的去留
			if noise1.get_noise_2dv(local_vector)*noise1.get_noise_2dv(local_vector) < noise2.get_noise_2dv(local_vector)*noise2.get_noise_2dv(local_vector):
				array.append(local_vector)
	
	for x in range(player_borth_position.x-3,player_borth_position.x+3):
		for y in range(player_borth_position.y-5,player_borth_position.y+5):
			var local_vector:Vector2i = area_id*16+Vector2i(x,y)
			array.erase(local_vector)
	
	#区块生成后存回data
	var a:AreaBlock = AreaBlock.new()
	a.block_cells = array
	blocks_areas[area_id] = a ## 字典增加[Vector2i]:[AreaBlock]
