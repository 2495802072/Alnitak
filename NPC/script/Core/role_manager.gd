## 管理世界内所有roles
class_name RoleManager extends Node

var player_name_list:Array[String] = [] ## 储存玩家昵称列表，防止重名以及防止重复加载
@export var player_root:Node2D ## 保存玩家根节点，在Godot编辑器绑定
@export var other_role_root:Node2D## 保存其他roles根节点，在Godot编辑器绑定

var static_role_list:Array = [] ##受世界决定，由[method _build_role_list]函数实现

var role_instance_index:int = 0 ## 实例化编号
var role_instance_list:Dictionary = {} ## 实例化role的列表{编号：roleBase}

var player_sence := preload("res://NPC/scene/Player.tscn")

func _ready():
	reset_players_name_list() ## 每次重启游戏都重置玩家名字列表

func create_player(player_data:PlayerData) -> void: ## 创建玩家
	var player := player_sence.instantiate()
	player.data = player_data
	player.name = player_data.player_name
	add_player(player)

func add_player(player:Node2D): ## 添加玩家
	player_root.add_child(player)

func _get_role_instance_index() -> int: ##获取role固定编号
	var i:int = role_instance_index
	role_instance_index += 1
	return i

func get_players_name_list() -> Array:
	return player_name_list

func add_player_name_to_list(s:String) -> void:
	player_name_list.append(s)
	pass

func reset_players_name_list() -> void:
	player_name_list = []

func _build_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]建立列表
	pass

func _clear_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]清空列表
	pass

func get_player_root() -> Node2D: ## 获取玩家根节点
	return player_root

func get_other_role_root() -> Node2D: ## 获取其他角色根节点
	return other_role_root

func save_player_data(player_name:String): ## 保存玩家数据
	
	pass
