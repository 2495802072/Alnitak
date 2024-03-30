## 区块类,暂定16*16为一个区块，存储玩家加载过的区块
class_name AreaBlock extends Resource

@export var block_layer:int ## 方块 层
@export var block_cells:PackedVector2Array## 存储区块内的方块(储存实体方块)
@export var block_terrain_set:int ## 方块的地形集编号
@export var block_terrain:int ## 方块的地形集内的地形编号
