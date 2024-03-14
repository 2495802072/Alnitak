class_name PlayerBase extends RoleBase

var clan = RoleBase.CLAN.PLAYER ##默认设定类型为[玩家],详情->[enum RoleBase.CLAN]
@export var player_name:String ## 玩家昵称,同时决定了玩家保存数据时的文件名称
var player_bag:Array[int]

@export var animated_sprite:AnimatedSprite2D
@export var collision_shape:CollisionShape2D

# var player_data:PlayerData

func _ready():
	if config:
		animated_sprite.sprite_frames = config.sprit_frames
		collision_shape.shape = config.collision_shape
	else:
		printerr("角色模型获取失败")

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		pass
	pass

func _save_file() -> void:
	G._get_role_manager().save_player_data(player_name)

func _rename() ->void:
	pass
