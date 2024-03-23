class_name WorldData extends Resource

@export var world_name:String
@export var difficult := WorldManager.DIFFICULTIES.EASY
@export var block:Array[AreaBlock]
@export var seed:int
@export var tile_set:TileSet

@export var enemy_list:Array
