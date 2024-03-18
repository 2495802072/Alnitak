extends CharacterBody2D

var data:PlayerData ## 使用Recource存储游戏数据

@export var animated_sprite:AnimatedSprite2D
@export var collision_shape:CollisionShape2D
var instance_id:int = -1 ## 角色被分配的ID

@onready var manager:RoleManager = G._get_role_manager() as RoleManager
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if data and data.config:
		animated_sprite.set_sprite_frames(data.config.sprit_frames)
		collision_shape.set_shape(data.config.collision_shape)
		position = data.player_position
	else:
		printerr("角色模型获取失败")

func _physics_process(delta):## 跳跃代码未加
	#if not is_on_floor():
		#velocity.y += gravity * delta
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = data.jump_velocity
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * data.speed
	else:
		velocity.x = move_toward(velocity.x, 0, data.speed)
	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		remove_self()


func attack() -> void: ##施加伤害
	pass

func save_file() -> void: ## 正常保存，使用资源自带路径，重命名请使用[method PlayerData.save_as_player]
	data.player_position = position
	ResourceSaver.save(data)

func remove_self() -> void:
	save_file()
	manager.remove_player(instance_id)
