class_name WorldManager extends Node

signal player_enter_chunk(chunk_id:Vector2i)
signal world_selected_over() ##世界选择结束，取消选择也产生信号

@export var world_root:TileMap ## 世界根节点， 编译器属性直接赋值
@export var chunk_sence:PackedScene ## 区块场景，编译器属性直接赋值
@onready var chunk_size:Vector2i = Vector2i(8,8) ##区块的尺寸(正方形)


var players_position:Dictionary##存储玩家们的坐标 [uid]:Vector2
var player_chunks:Array[Vector2i] ##存储玩家们的区块
var loading_radius:Vector2i = Vector2i(3,2) ##区块加载半径
var loaded_chunks:Array[Vector2i] = [] ##已加载区块
var chunk_nodes:Dictionary = {} ##区块的节点

var world_data:WorldData ##存储世界数据

var world_completed:bool = false 

func _init_data(data:WorldData):##初始化
	world_data = data
	players_position = Dictionary(world_data.player_position)
	for player_position in players_position.values():
		var p_chunk_pos:Vector2i = _to_chunk(player_position)
		player_chunks.append(p_chunk_pos)
	#根据玩家的区块s加载地图
	_generate_chunk(player_chunks)
	world_completed = true
	world_selected_over.emit()
	pass

func _process(_delta):
	if multiplayer.is_server(): ## 仅主机端负责更新区块，客户端只需同步即可
		_update_chunks()

func _update_chunks() -> void:
	var new_palyer_chunks:Array[Vector2i] = []
	for player in players_position.keys():
		var player_pos: Vector2 = _get_player_position(player)
		var player_chunk:Vector2i = _to_chunk(player_pos)
		#触发玩家进入区块的信号
		if  player_chunk != _to_chunk(players_position[player]):
			players_position[player] = player_pos
			player_enter_chunk.emit(player_chunk)
		new_palyer_chunks.append(player_chunk)
		
	# 玩家所在区块s发生变化时
	if new_palyer_chunks != player_chunks:
		player_chunks = new_palyer_chunks
		_generate_chunk(player_chunks)

func _generate_chunk(center_chunk_array:Array[Vector2i]) -> void: ## 以中心区块计算生成区块
	var array:Array[Vector2i] = [] ## 当前需要加载的区块数组
	
	#计算需要的区块
	#多人游戏区块加载要求多核 
	for center_chunk in center_chunk_array:
		var start:Vector2i = center_chunk - loading_radius
		var end:Vector2i = center_chunk + loading_radius
		for x in range(start.x,end.x+1):
			for y in range(start.y,end.y+1):
				var chunk_id:Vector2i = Vector2i(x,y)
				if not array.has(chunk_id):
					array.append(chunk_id)
				if not loaded_chunks.has(chunk_id): ##只更新未加载的区块
					#print("更新区块")
					_add_chunk_node(chunk_id)
					#printerr(chunk_id)
					loaded_chunks.append(chunk_id)
			
	
	#计算不需要的区块
	for chunk in loaded_chunks:
		if not array.has(chunk):
			#print("移除区块")
			_remove_chunk(chunk)
			#printerr(chunk)
			

func _add_chunk_node(chunk_id:Vector2i) -> void: ##将区块节点添加至worldRoot
	var chunk:ChunkNode = chunk_sence.instantiate()
	chunk.chunk_id = chunk_id ##设置区块编号
	chunk.name = str(chunk_id)
	chunk.noise = world_data.world_seed ## 设置地图噪声
	chunk.size = chunk_size ##区块大小
	chunk.position = world_root.map_to_local(chunk_id*chunk_size) ##区块的local坐标
	chunk.chunk_root = world_root ##区块的根节点
	chunk.manager = self 
	chunk.tile_set = world_root.tile_set
	chunk.world_data = world_data
	world_root.add_child(chunk)
	chunk_nodes[chunk_id] = chunk
	pass

func _remove_chunk(chunk_id:Vector2i) -> void:
	if chunk_nodes.has(chunk_id):
		var chunk:ChunkNode = chunk_nodes[chunk_id]
		if chunk.queue_self(): ## 因为线程有可能滞后一点，需要确认是否正常释放
			chunk_nodes.erase(chunk_id)
			loaded_chunks.erase(chunk_id)
	pass

func _to_chunk(pos:Vector2) -> Vector2i:
	var chunk_vec:Vector2 = pos/Vector2(chunk_size)
	return Vector2i(chunk_vec.floor())

func _update_players_position() -> void: ##仅在有玩家进入/退出时调用
	var dic:Dictionary = G._get_role_manager().get_player_positions()
	for key in dic.keys():
		players_position[key] = world_root.local_to_map(dic[key])
	ResourceSaver.save(world_data)
	
func _get_player_position(player_uid:String) -> Vector2i: ##本节点获取玩家的坐标
	#当前所有玩家的字典
	var dic:Dictionary = G._get_role_manager().get_player_positions()
	var p_pos:Vector2i = Vector2i.ZERO
	if dic.has(player_uid):
		p_pos = world_root.local_to_map(dic[player_uid])
	return p_pos

func get_player_position(player_uid:String) -> Vector2: ##其他节点获取存于地图的玩家坐标
	print("获取玩家坐标")
	var pos:Vector2i = world_data.player_borth_position
	if world_data.player_position.has(player_uid):
		pos = world_data.player_position[player_uid]
	else:
		print("获取玩家坐标失败,使用默认坐标")
	player_chunks.append(pos)
	_generate_chunk(player_chunks)
	var local:Vector2 = world_root.map_to_local(pos)
	return local

func selected_world() -> bool:
	world_completed = false
	G._get_view_manager().open_view("WorldSelect")
	await world_selected_over
	return world_completed
	
