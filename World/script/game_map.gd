extends TileMap

signal player_leave_chunk(player_index:int,chunk_id:Vector2i)##玩家离开区块时发出
signal player_enter_chunk(player_index:int,chunk_id:Vector2i)##玩家进入区块时发出
signal player_chunk_changed(player_index:int,leave_chunk:Vector2i,enter_chunk:Vector2i)## 玩家区块发生改变时发出,刚加入地图时,不会发出


@export var data:WorldData

var player_chunks:Dictionary = {}#单人模式只有一个
var world_name:String

var left_up_chunk_id:Vector2i ##加载区块范围左上角
var right_down_chunk_id:Vector2i ##加载区块范围右下角

func _ready():
	if data:
		world_name = data.world_name
		name = data.world_name
	var player_chunk:Vector2i = get_chunk_id(data.player_borth_position)
	left_up_chunk_id = player_chunk + Vector2i(-5,-4) ## TODO 当前加载区块范围为固定值，建议之后修改为随摄像机变化
	right_down_chunk_id = player_chunk + Vector2i(4,3)
	for chunk_x in range(left_up_chunk_id.x,right_down_chunk_id.x+1):
		for chunk_y in range(left_up_chunk_id.y,right_down_chunk_id.y+1):
			var chunk = Vector2i(chunk_x,chunk_y)
			generate_world_chunk(chunk) ## 玩家出生地区块s生成
	pass

func _process(_delta):
	if G._get_role_manager().count_player_velocity() == Vector2.ZERO: ##玩家没有移动时，不计算区块
		return
	else:
		var player_positions_in_local:Array[Vector2] = G._get_role_manager().get_player_positions()
		var index:int = 0 ## 若有必要，这里需要改成玩家名称 or UID 
		for player_position_in_local in player_positions_in_local:
			var player_position_in_map:Vector2i = local_to_map(player_position_in_local)
			var player_chunk:Vector2i = get_chunk_id(player_position_in_map)
			if player_chunks.has(index):
				if player_chunk != player_chunks[index]:
					player_leave_chunk.emit(index,player_chunks[index])
					player_enter_chunk.emit(index,player_chunk)
					player_chunk_changed.emit(index,player_chunks[index],player_chunk)
			else:
				player_enter_chunk.emit(index,player_chunk)
			index += 1

func get_chunk_id(pos:Vector2) -> Vector2i:  ## pos必须是map内部的坐标，如果不是，请使用local_to_map()转换
	var x:int = pos.x/16
	var y:int = pos.y/16
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

func _on_player_leave_chunk(index:int,chunk_id:Vector2i) -> void:
	#print("玩家"+str(index)+"离开区块"+str(chunk_id))
	pass

func _on_player_enter_chunk(index:int,chunk_id:Vector2i) -> void:
	player_chunks[index] = chunk_id
	print("玩家"+str(index)+"进入区块"+str(chunk_id))

func _on_player_chunk_changed(player_index, leave_chunk, enter_chunk) -> void:
	pass # Replace with function body.
