extends TileMap
class_name ChunkNode

@export var l0_tile_data:PackedInt32Array

@onready var multiplayer_synchronizer:MultiplayerSynchronizer = $MultiplayerSynchronizer as MultiplayerSynchronizer


var chunk_id:Vector2i
var noise:int
var size:Vector2i
var chunk_root:TileMap
var manager:WorldManager
var world_data:WorldData
var task_id:int ##线程任务id
var task_completed:bool = false ##线程任务完成标识，不完成拒绝释放

func _ready():
	if multiplayer.is_server():
		#if chunk_id != Vector2i.ZERO: # TODO 出生区块破坏，防止卡墙，阻止生成会有衔接问题
		task_id = WorkerThreadPool.add_task(thread_generate,true) # 主机使用线程加载 TODO 添加判断是否存在本地数据
	else:
		await multiplayer_synchronizer.synchronized # 访客使用主机资源
		set("layer_0/tile_data",l0_tile_data)
		pass

func _process(_delta): ##实时获取该区块是否完成
	if multiplayer.is_server():
		##这个区块释放最好实时检测，不然有时候线程出现些许滞后会导致区块残留
		task_completed = WorkerThreadPool.is_task_completed(task_id)

func thread_generate()->void: ##线程生成地图
	var array:Array[Vector2i] = []
	var array_noblock:Array[Vector2i] = []
	var earse_array:Array[Vector2i] = []
	
	for x in range(-1,size.x+1): #区块范围（0，0）到（size,size）,多算一圈，防止区块衔接不可合理
		for y in range(-1,size.y+1):
			#当前图格 的坐标，统一（0，0）到（size,size）,因为区块的全局坐标在父级设置了，所以每个区块仅须管好自己
			var local_vector:Vector2i = Vector2i(x,y)
			
			# 调用data的create_way判断是否添加图格
			if world_data.create_way._create_block(chunk_id,local_vector,noise,size):
				array.append(local_vector) #填充图格
			else:
				array_noblock.append(local_vector)#空白图格
			
			#消除外围一圈的衔接用图格
			if x in [-1,size.x] or y in [-1,size.y]:
				earse_array.append(local_vector)
	
	set_cells_terrain_connect(0,array,0,1)
	for earse_vector in earse_array:
		erase_cell(0,earse_vector)
	
	#主线程设置图格
	call_deferred("_generate_finished",get("layer_0/tile_data"))
	pass

##由主线程设置图格
func _generate_finished(tile_data:PackedInt32Array) -> void:
	l0_tile_data = tile_data
	pass

func queue_self() -> bool: ##当前区块释放自己
	if task_completed:
		#print(chunk_id)
		#printerr("释放自己")
		queue_free()
		return true ##成功释放返回true
	else:
		return false
