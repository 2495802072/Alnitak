## 管理世界内所有roles
class_name RoleManager extends Node

var player_name_list:Array[String] = [] ## 储存玩家昵称列表，防止重名以及防止重复加载
@export var player_root:Node2D ## 编译器属性直接赋值
@export var other_role_root:Node2D## 编译器属性直接赋值
@export var player_sence:PackedScene ## 编译器属性直接赋值

var static_role_list:Array = [] ##受世界决定，由[method _build_role_list]函数实现

@export var role_instance_index:int = 0 ## 实例化编号
var role_instance_list:Dictionary = {} ## 实例化role的列表{int：Node2}

var lcoal_player_data:PlayerData ##role_selected时进行设置

func _ready():
	pass

func save_player_file() -> void: ## 正常保存，使用资源自带路径，重命名请使用[method PlayerData.save_as_player]
	ResourceSaver.save(lcoal_player_data)

func set_lcoal_player_data(player_data:PlayerData) -> void:
	lcoal_player_data = player_data

func get_players_name_list() -> Array:
	return player_name_list

func add_player_name_to_list(s:String) -> void:
	player_name_list.append(s)

func reset_players_name_list() -> void:
	player_name_list = []


func create_player(config_path:String,player_name:String) -> Node2D: ## 创建玩家
	var player:Node2D = player_sence.instantiate()
	player.instance_id = _get_role_instance_index()
	player.config_path = config_path
	
	print("创建玩家" + player_name)
	return player
	

@rpc("any_peer","call_local","reliable")
func add_player(config_path:String,player_name:String,player_uid:String): ## 添加玩家
	var player:Node2D = create_player(config_path,player_name)
	if not G._get_world_manager().world_completed: ##世界未建立
		printerr("world is not completed")
		return
	#找到玩家存储在地图数据内的坐标
	player.position = G._get_world_manager().get_player_position(player_uid)
	
	# 设置操作权限 
	if multiplayer.get_remote_sender_id() == 0:
		player.name = str(1) ##节点名称设置为联机配置的编号
	else:
		player.name = str(multiplayer.get_remote_sender_id()) ##节点名称设置为联机配置的编号
		
	
	_add_to_role_instance_list(player)
	player_root.add_child(player)
	
	G.game_entered.emit() ##到这里，已经完全进入游戏（脱离菜单页面）
	
	G._get_world_manager()._update_players_position() ##玩家加入后，更新地图存储的玩家坐标

func _get_role_instance_index() -> int: ##获取role固定编号 TODO 完作请考虑使用内置方法get_instance_id()
	var i:int = role_instance_index
	role_instance_index += 1
	return i

@rpc("any_peer","call_local","reliable")
func _add_to_role_instance_list(role:Node2D) -> void:
	role_instance_list[role.instance_id] = role

@rpc("any_peer","call_local","reliable")
func _get_node_by_instance_id(i:int) -> Node2D:
	return role_instance_list[i]

@rpc("any_peer","call_local","reliable")
func get_player_root() -> Node2D: ## 获取玩家根节点
	return player_root

@rpc("any_peer","call_local","reliable")
func get_other_role_root() -> Node2D: ## 获取其他角色根节点
	return other_role_root

@rpc("any_peer","call_local","reliable")
func remove_player(instance_index:int): ## 玩家退出时，坐标数据存到地图数据里
	var player_to_leave:Node2D = _get_node_by_instance_id(instance_index)
	G._get_world_manager()._update_players_position()
	role_instance_list.erase(instance_index)
	G._get_palyer_camera().player_exit()
	player_to_leave.queue_free()


func get_player_positions() -> Dictionary: ##返回所有玩家的坐标数据
	var dic:Dictionary = {}
	for player in player_root.get_children():
		var pos:Vector2 = player.position
		var uid:String = player.get("uid")
		dic[uid] = pos
	return dic

@rpc("any_peer","call_local","reliable")
func count_player_velocity() -> Vector2: ##统计玩家速度总和，静默时减少内存消耗
	var v_sum:Vector2 = Vector2.ZERO
	for player in player_root.get_children():
		var v:Vector2 = player.velocity
		v_sum += v
	return v_sum

@rpc("any_peer","reliable")
func set_player_camera(node_name:String) -> void:
	print("设置相机跟随对象")
	var player:Node2D = player_root.get_node_or_null(node_name)
	G._get_palyer_camera().player = player ##设置相机跟随对象
	G._get_palyer_camera().change_mode_to(1)

#TODO

func _build_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]建立列表
	pass

func _clear_role_list() -> void: ## 每个世界存在自定义的role种类，但是统一由[RoleManager]管理，此函数用于给[RoleManager]清空列表
	pass
