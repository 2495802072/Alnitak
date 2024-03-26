class_name WorldManager extends Node

signal world_ready() ##有世界被加载后发出

@export var world_root:Node2D ##编译器属性直接赋值
@export var world_sence:PackedScene ## 编译器属性直接赋值

var world_complete:bool = false
var world_data_now:WorldData
var world_map:TileMap

func _ready():
	pass

func create_world(world_data:WorldData) -> void:
	var map:TileMap = world_sence.instantiate()
	map.data = world_data
	map.name = world_data.world_name
	world_data_now = world_data
	world_map = map
	add_world(map)

func add_world(node:TileMap) -> void:
	world_root.add_child(node)
	world_complete = true
	world_ready.emit()

func world_had_completed() -> bool:
	return world_complete

func get_world_data_now() -> WorldData:
	return world_data_now

func save_player_position(player_uid:String,pos:Vector2) -> void:
	if world_map: ##因为tilemap内部采用的map坐标和local坐标有差别，所以要通过tilemap转换一下
		world_map.save_player_position_to_map(player_uid,pos)
	else:
		print("世界未发现")

func load_player_position(player_uid:String) -> Vector2:
	if world_map:
		return world_map.find_player_position_in_data(player_uid)
	else:
		print("世界未发现")
		return Vector2.ZERO
