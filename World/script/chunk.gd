extends TileMap
class_name ChunkNode

@export var l0_tile_data:PackedInt32Array

@onready var multiplayer_synchronizer:MultiplayerSynchronizer = $MultiplayerSynchronizer as MultiplayerSynchronizer


var chunk_id:Vector2i
var noise:int
var size:Vector2i
var chunk_root:TileMap
var manager:WorldManager

var task_id:int ##线程任务id
var task_completed:bool = false ##线程任务完成标识，不完成拒绝释放

func _ready():
	if multiplayer.is_server():
		task_id = WorkerThreadPool.add_task(thread_generate,true) ##使用线程加载
	else:
		await multiplayer_synchronizer.synchronized
		
		set("layer_0/tile_data",l0_tile_data)
		pass

func _process(_delta): ##实时获取该区块是否完成
	if multiplayer.is_server():
		##这个区块释放最好实时检测，不然有时候线程出现些许滞后会导致区块残留
		task_completed = WorkerThreadPool.is_task_completed(task_id)

func thread_generate()->void: ##线程生成地图
	var array:Array[Vector2i] = []
	var noise1:FastNoiseLite = FastNoiseLite.new()
	var noise2:FastNoiseLite = FastNoiseLite.new()
	noise1.set_seed(noise)
	noise2.set_seed(noise-1)
	
	
	for x in range(size.x): ##区块范围（0，0）到（size,size）
		for y in range(size.y):
			
			var local_vector:Vector2i = Vector2i(x,y)##当前tilemap 的坐标，统一（0，0）到（size,size）
			var noise_vector:Vector2i = chunk_id*size+local_vector ##该点的噪声坐标，由map管理提供
			## 通过比较噪声的平方大小决定图格
			if noise1.get_noise_2dv(noise_vector)*noise1.get_noise_2dv(noise_vector) < noise2.get_noise_2dv(noise_vector)*noise2.get_noise_2dv(noise_vector):
				array.append(local_vector)
				
				
	
	#主线程设置图格
	
	call_deferred("_generate_finished",array)
	pass

##由主线程设置图格
func _generate_finished(tile_data:Array) -> void:
	set_cells_terrain_connect(0,tile_data,0,0)
	l0_tile_data = get("layer_0/tile_data")
	pass

func queue_self() -> bool: ##当前区块释放自己
	if task_completed:
		#print(chunk_id)
		#printerr("释放自己")
		queue_free()
		return true ##成功释放返回true
	else:
		return false
