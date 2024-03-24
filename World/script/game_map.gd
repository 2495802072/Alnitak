extends TileMap

@export var data:WorldData

var world_name:String

func _ready():
	if data:
		world_name = data.world_name
		name = data.world_name
	generate_world_area(data.player_borth_position) ## 玩家出生地区块生成
	
	pass

func generate_world_area(id:Vector2i) ->void: #从data生成区块
	if data.blocks_areas.has(id):
		print("已知区块")
		var area:AreaBlock = data.blocks_areas[id] as AreaBlock
		set_cells_terrain_connect(area.block_layer,area.block_cells,area.block_terrain_set,area.block_terrain)
	else:
		var array = data._get_blocks_array(id)
		set_cells_terrain_connect(0,array,0,0)
	pass


