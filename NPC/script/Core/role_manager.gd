## 管理世界内所有roles
class_name RoleManager extends Node

var player_name_list:Array[String] = [] ## 储存玩家昵称列表，防止重名以及防止重复加载
@export var player_root:Node2D ## 编译器属性直接赋值
@export var other_role_root:Node2D## 编译器属性直接赋值
@export var player_sence:PackedScene

var static_role_list:Array = [] ##受世界决定，由[method _build_role_list]函数实现

var role_instance_index:int = 0 ## 实例化编号
var role_instance_list:Dictionary = {} ## 实例化role的列表{int：Node2}

func _ready():
	pass

func create_player(player_data:PlayerData) -> void: ## 创建玩家
	var player:Node2D = player_sence.instantiate()
	player.data = player_data
	player.name = player_data.player_name
	add_player(player)

func add_player(player:Node2D): ## 添加玩家
	player.instance_id = _get_role_instance_index()
	_add_to_role_instance_list(player)
	player_root.add_child(player)

func _get_role_instance_index() -> int: ##获取role固定编号
	var i:int = role_instance_index
	role_instance_index += 1
	return i

func _add_to_role_instance_list(role:Node2D) -> void:
	role_instance_list[role.instance_id] = role

func _get_node_by_instance_id(i:int) -> Node2D:
	return role_instance_list[i]

func get_players_name_list() -> Array:
	return player_name_list

func add_player_name_to_list(s:String) -> void:
	player_name_list.append(s)

func reset_players_name_list() -> void:
	player_name_list = []

func get_player_root() -> Node2D: ## 获取玩家根节点
	return player_root

func get_other_role_root() -> Node2D: ## 获取其他角色根节点
	return other_role_root

func remove_player(instance_index:int): ## 玩家退出时，移除玩家(触发此函数前已保存)
	var player_to_leave:Node2D = _get_node_by_instance_id(instance_index)
	role_instance_list.erase(instance_index)
	player_to_leave.queue_free()

#TODO

func _build_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]建立列表
	pass

func _clear_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]清空列表
	pass
