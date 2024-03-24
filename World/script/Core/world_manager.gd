class_name WorldManager extends Node

signal world_ready() ##有世界被加载后发出

@export var world_root:Node2D ##编译器属性直接赋值
@export var world_sence:PackedScene ## 编译器属性直接赋值

var world_complete:bool = false
var world_data_now:WorldData

func _ready():
	pass

func create_world(world_data:WorldData) -> void:
	var map:TileMap = world_sence.instantiate()
	map.data = world_data
	map.name = world_data.world_name
	world_data_now = world_data
	add_world(map)

func add_world(node:TileMap) -> void:
	world_root.add_child(node)
	world_complete = true
	world_ready.emit()

func has_world() -> bool:
	return world_complete

func get_world_data_now() -> WorldData:
	return world_data_now
