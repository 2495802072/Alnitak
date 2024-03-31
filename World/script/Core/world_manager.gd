class_name WorldManager extends Node

signal initialized() ##初始化完成发出，及获得世界数据
signal world_ready() ##世界被加载后发出
signal player_enter_chunk(chunk_id:Vector2i)

@export var world_root:TileMap ## 世界根节点， 编译器属性直接赋值
@export var chunk_sence:PackedScene ## 区块场景，编译器属性直接赋值
@export var chunk_size:Vector2i = Vector2i(16,16) ##区块的尺寸(正方形)

var players_position:Dictionary##存储玩家们的坐标 [uid]:Vector2
var loading_radius:Vector2i = Vector2i(2,1) ##区块加载半径
var loaded_chunks:Array[Vector2i] = [] ##已加载区块
var chunk_nodes:Dictionary = {} ##区块的节点

var world_data:WorldData ##存储世界数据

func _ready():
	await initialized
	for player_position in players_position.values():
		var p_chunk_pos:Vector2i = _to_chunk(player_position)
		_generate_chunk(p_chunk_pos)
	world_ready.emit()

func _init_data(data:WorldData):##初始化
	world_data = data
	players_position = Dictionary(world_data.player_position)
	initialized.emit()
	pass

func _process(delta):
	if G._get_role_manager().count_player_velocity() != Vector2.ZERO:
		_update_chunks()

func _update_chunks() -> void:
	for player in players_position.keys():
		var player_pos: Vector2 = _get_player_position(player)
		var player_chunk:Vector2i = _to_chunk(player_pos)
		
		if  player_chunk != _to_chunk(players_position[player]):
			players_position[player] = player_pos
			player_enter_chunk.emit(player_chunk)
			_generate_chunk(player_chunk)

func _generate_chunk(center_chunk:Vector2i) -> void: ## 以中心区块计算生成区块
	var start:Vector2i = center_chunk - loading_radius
	var end:Vector2i = center_chunk + loading_radius
	
	#计算需要的区块
	var array:Array[Vector2i] = []
	for x in range(start.x,end.x+1):
		for y in range(start.y,end.y+1):
			var chunk_id:Vector2i = Vector2i(x,y)
			array.append(chunk_id)
			if not loaded_chunks.has(chunk_id): ##只更新未加载的区块
				_add_chunk_node(chunk_id)
				#print("更新区块")
				#printerr(chunk_id)
				loaded_chunks.append(chunk_id)
			
	
	#计算不需要的区块
	var remove:Array[Vector2i] = []
	for chunk in loaded_chunks:
		if not array.has(chunk):
			_remove_chunk(chunk)
			#print("移除区块")
			#printerr(chunk)
			

func _add_chunk_node(chunk_id:Vector2i) -> void: ##将区块节点添加至worldRoot
	var chunk:ChunkNode = chunk_sence.instantiate()
	chunk.chunk_id = chunk_id
	chunk.noise = world_data.world_seed
	chunk.size = chunk_size
	chunk.position = world_root.map_to_local(chunk_id*chunk_size)
	chunk.manager = self
	world_root.add_child(chunk)
	chunk_nodes[chunk_id] = chunk
	pass

func _remove_chunk(chunk_id:Vector2i) -> void:
	if chunk_nodes.has(chunk_id):
		var chunk:ChunkNode = chunk_nodes[chunk_id]
		if chunk.queue_self(): ## 因为线程有可能滞后一点，所有确认是否正常释放
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
	_generate_chunk(pos)
	var local:Vector2 = world_root.map_to_local(pos)
	return local

