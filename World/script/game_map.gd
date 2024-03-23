extends TileMap

@export var data:WorldData

var world_name:String

func _ready():
	if data:
		world_name = data.world_name
	pass

func generate_world() ->void: ##生成世界
	var noise = FastNoiseLite.new()
	noise.set_seed(data.seed)
	pass
