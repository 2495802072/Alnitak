extends Node2D

var data:PlayerData ## 使用Recource存储游戏数据

@export var animated_sprite:AnimatedSprite2D
@export var collision_shape:CollisionShape2D
var instance_id:int = -1 ## 角色被分配的ID

#func _init():
	#animated_sprite = $AnimatedSprite2D as AnimatedSprite2D
	#collision_shape = $RigidBody2D/CollisionShape2D as CollisionShape2D

func _ready():
	if data and data.config:
		animated_sprite.set_sprite_frames(data.config.sprit_frames)
		collision_shape.set_shape(data.config.collision_shape)
	else:
		printerr("角色模型获取失败")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		pass
	pass

func attack() -> void:
	pass

func _save_file() -> void:
	ResourceSaver.save(data)

func _rename() ->void:
	pass
