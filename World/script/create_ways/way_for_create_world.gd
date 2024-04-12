##世界生成规则大类
class_name WorldCreateWays extends Resource

enum RULES{ ## 规则的类别
	CREATED, ##世界创建时触发
	WITH_TIME, ## 随时间触发
}

## 转化为tile数据[br]
## [code]coords[/code] 图格坐标，[br]
## [code]source_id[/code] ，[code]atlas_coords[/code] ，[code]alternative_tile[/code] 图格属性"三件套"
## -> 详情：[method TileMap.set_cell][br]
##[code]transpose[/code] ，[code]flip_v[/code] ，[code]flip_h[/code] 分别是转置，垂直翻转，水平翻转[br]
## [codeblock]
## # 设置图格
## func _set_tile_data():
##     # 设置Vector2i(2,1)的格子为0号层的第Vector2i(1,1)个图格,转为二进制就可以很直观
##     var tile_data:PackedInt32Array = [131073,65536,1]
##     set("layer_0/tile_data",tile_data)
## [/codeblock][br]
## [param 特别鸣谢]: [br]
## [i]@Author: 文雨 (Github)[/i]
static func to_tile_data(coords:Vector2i,
	source_id:int,atlas_coords:Vector2i,alternative_tile:int,
	transpose:bool,flip_v:bool, flip_h:bool) -> PackedInt32Array:
	
	var tile_data:PackedInt32Array = []
	
	# 第1位32位整数前16位表示坐标的y，后16位表示坐标x
	# | 拼接符号
	# << 左移符号 (1 << 16）表示把1左移16位 相当于  * 2^16
	var coords_32 :int = int(coords.y) << 16 | int(coords.x)
	tile_data.append(coords_32)

	# 第2位32位整数前16位表示图集坐标的x，后16位表示源id
	var atlas_source_32 :int = int(atlas_coords.x) << 16 | int(source_id)
	tile_data.append(atlas_source_32)

	# 第3位32位整数的第1位是0，因为这是一个整数，
	#如果转置是true第2位是1否则位0
	var int_32 :int = (1 if transpose else 0) << 1 # 特别注意，这里已经设置了2位了，“ 01 ” ,（初始化 = 0）
	# 如果垂直翻转为true则第3位为1否则为0
	int_32 = (int_32 | (1 if flip_v else 0)) << 1
	# 如果水平翻转为true则第4位为1否则为0
	int_32 = (int_32 | (1 if flip_h else 0)) << 28
	# 后12位表示备选
	int_32 = int_32 | (alternative_tile << 16)
	# 最后的16位是图集坐标y
	int_32 = int_32 | int(atlas_coords.y)

	tile_data.append(int_32)
	return tile_data

func _create():
	pass
