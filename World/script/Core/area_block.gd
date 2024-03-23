## 区块类,默认16*16为一个区块
class_name AreaBlock extends Resource

@export var id:Vector2i
@export var array:Array[Vector3i]## 存储玩家改动过的格子（x,y,id)

func generate_block_array() -> void:
	var glo_v2i = id*16
	for x:int in range(1,16) :
		for y:int in range(1,16):
			_set_block(Vector2(x,y))
	pass

func _set_block(path:Vector2):
	pass
