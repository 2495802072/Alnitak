extends TileMap

@export var data:WorldData

var player_position_in_map:Vector2i
var world_name:String

func _ready():
	if data:
		world_name = data.world_name
		name = data.world_name
	var player_chunk:Vector2i = get_chunk_id(data.player_borth_position)
	generate_world_chunk(player_chunk) ## 玩家出生地区块生成
	pass

func get_chunk_id(pos:Vector2) -> Vector2i:
	var position_map = local_to_map(pos)
	var x:int = position_map.x/16
	var y:int = position_map.y/16
	return Vector2i(x,y)

func generate_world_chunk(chunk_id:Vector2i) ->void: #从data生成区块
	if data.chunks.has(chunk_id):
		#print("已知区块")
		var area:AreaBlock = data.chunks[chunk_id] as AreaBlock
		set_cells_terrain_connect(area.block_layer,area.block_cells,area.block_terrain_set,area.block_terrain)
	else:
		#print("生成新区块")
		var array = data._create_blocks_array(chunk_id)
		set_cells_terrain_connect(0,array,0,0)
	_save_map_data()

func save_player_position_to_map(player_uid:String,pos_local:Vector2) -> void:
	var pos_map:Vector2i = local_to_map(pos_local)
	data.player_position[player_uid] = pos_map #存入玩家uid：地图内坐标
	_save_map_data()

func find_player_position_in_data(player_uid:String) -> Vector2:
	var pos_map:Vector2i = data.player_borth_position
	if data.player_position.has(player_uid):
		#print("找到玩家数据")
		pos_map= data.player_position[player_uid]
	return map_to_local(pos_map)

func _save_map_data() -> void:
	ResourceSaver.save(data)
