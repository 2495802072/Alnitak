## 所有角色的基类，具备一些角色必要属性
class_name RoleBase extends Node2D
signal make_attack(target:int,damage:int) ## 造成伤害时发出信号，target是伤害目标的ID,damage是伤害量

## 以下为需要保存的数据
@export var config:ChartletConfig ## 保存角色模型 ，贴图以及对应的碰撞体积
var HP_base:int = 100 ##角色基础血量
var HP_buff:float = 1 ## 角色血量增益
var MP_base:int = 0 ##角色基础蓝量
var ATK_base:int = 1 ##角色基础攻击力,角色实际攻击力 = ATK_base*ATK_buff
var ATK_buff:float = 1 ##角色攻击力增益,角色实际攻击力 = ATK_base*ATK_buff
var DEF_base:int = 1 ##角色基础防御力,角色实际防御力 = DEF_base*DEF_buff
var DEF_buff:float = 1 ##角色防御力增益,角色实际防御力 = DEF_base*DEF_buff
@export var buff_list:Array ## TODO 角色增益列表


var instance_id:int = -1 ## 角色被分配的ID

enum CLAN{
	PLAYER, ## 玩家
	ENEMY,## 敌人
	NPC ## 其他中立role
}

func _attack(target:int): ## 对target造成伤害
	var damage = ATK_base*ATK_buff;
	make_attack.emit(target,damage)
	
	pass

func _be_hurt(damage:int): ## 受伤
	pass
