extends TileMap
class_name ChunkNode

var chunk_id:Vector2i
var noise:int
var size:Vector2i

var task_id:int ##线程任务id
var task_completed:bool = false ##线程任务完成标识，不完成拒绝释放

func _ready():
	task_id = WorkerThreadPool.add_task(thread_generate,true) ##使用线程加载
	pass

func _process(_delta): ##实时获取该区块是否完成
	task_completed = WorkerThreadPool.is_task_completed(task_id)

func thread_generate()->void: ##线程生成地图
	var array:Array[Vector2i] = []
	var noise1:FastNoiseLite = FastNoiseLite.new()
	var noise2:FastNoiseLite = FastNoiseLite.new()
	noise1.set_seed(noise)
	noise2.set_seed(noise-1)
	
	
	for x in range(chunk_id.x*size.x,chunk_id.x*size.x+size.x+1): ##区块范围16*16
		for y in range(chunk_id.y*size.y,chunk_id.y*size.y+size.y+1):
			var local_vector:Vector2i = chunk_id+Vector2i(x,y)
			## 通过比较噪声的平方大小决定图格
			if noise1.get_noise_2dv(local_vector)*noise1.get_noise_2dv(local_vector) < noise2.get_noise_2dv(local_vector)*noise2.get_noise_2dv(local_vector):
				array.append(local_vector)
				
				
	
	var tile_data:PackedInt32Array = PackedInt32Array(array)
	call_deferred("_generate_finished",array)
	pass

##由主线程设置图格
func _generate_finished(tile_data:Array[Vector2i]):
	set_cells_terrain_connect(0,tile_data,0,0)
	#set("layer_土块/tile_data",tile_data)
	pass

func queue_self(): ##当前区块释放自己
	if task_completed:
		print(chunk_id)
		printerr("释放自己")
		queue_free()
