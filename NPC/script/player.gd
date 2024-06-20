extends CharacterBody2D

@export var config_path:String ## 贴图的地址
@onready var animated_sprite: = $AnimatedSprite2D as AnimatedSprite2D
@onready var collision_shape: = $CollisionShape2D as CollisionShape2D
@export var instance_id:int = -1 ## 角色被分配的ID

@export var manager:RoleManager
@export var data:PlayerData
@export var uid:String
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") # 重力

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	manager =  G._get_role_manager() as RoleManager
	if multiplayer.get_unique_id() == name.to_int():
		#本地设置相机跟随
		manager.set_player_camera(name)
		set_local_data()
	init_player()

func _physics_process(delta):
	##限制操作权限
	if multiplayer.get_unique_id() == name.to_int():
		
		if not is_on_floor():
			velocity.y += gravity * delta
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = data.jump_velocity
		
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * data.speed
		else:
			velocity.x = move_toward(velocity.x, 0, data.speed)
		move_and_slide()
		
		#打开UI
		if Input.is_action_just_pressed("ui_cancel"):
			pass
		
		##退出逻辑
		if Input.is_action_just_pressed("interact"):
			manager.save_player_file() ##客户端保存本地数据
			if not multiplayer.is_server():
				rpc_id(1,"remove_self")
				queue_free()
			else:
				remove_self()

@rpc("authority","reliable")
func set_local_data() -> void:
	data = G._get_role_manager().lcoal_player_data as PlayerData
	uid = data.UID
	pass

func attack() -> void: ##施加伤害
	pass

@rpc("any_peer") ##从服务端移除
func remove_self() -> void:
	manager.remove_player(instance_id) ## 主机移除并保存坐标

func init_player() -> void:
	if data:
		config_path = data.config.resource_path
	#注意：客户端投影config使用的 是角色创建之初传给主机端的地址
	var config = ResourceLoader.load(config_path,"ChartletConfig")
	animated_sprite.set_sprite_frames(config.sprit_frames)
	collision_shape.set_shape(config.collision_shape)

@rpc("any_peer","reliable")
func get_player_instance_id() -> int:
	return instance_id
