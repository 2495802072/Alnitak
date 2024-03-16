class_name ChartletConfig extends Resource

@export var name:StringName
@export var collision_shape:Shape2D
@export var sprit_frames:SpriteFrames

@export var icon:Texture2D

@export var HP_base:int  ##角色基础血量
@export var HP_buff:float  ## 角色血量增益
@export var MP_base:int  ##角色基础蓝量
@export var ATK_base:int  ##角色基础攻击力,角色实际攻击力 = ATK_base*ATK_buff
@export var ATK_buff:float  ##角色攻击力增益,角色实际攻击力 = ATK_base*ATK_buff
@export var DEF_base:int  ##角色基础防御力,角色实际防御力 = DEF_base*DEF_buff
@export var DEF_buff:float  ##角色防御力增益,角色实际防御力 = DEF_base*DEF_buff

@export var HP_UP:int ##HP恢复速度
@export var MP_UP:int ##MP恢复速度


func _get_collision_size() -> Rect2:
	return collision_shape.get_rect()
