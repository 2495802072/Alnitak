## 所有角色的基类，具备一些角色必要属性
class_name RoleBase extends Resource
signal make_attack(target:int,damage:int) ## 造成伤害时发出信号，target是伤害目标的ID,damage是伤害量

## 以下为需要保存的数据
@export var config:ChartletConfig ## 保存角色模型 ，贴图以及对应的碰撞体积
@export var HP_base:int  ##角色基础血量
@export var HP_buff:float  ## 角色血量增益
@export var MP_base:int  ##角色基础蓝量
@export var ATK_base:int  ##角色基础攻击力,角色实际攻击力 = ATK_base*ATK_buff
@export var ATK_buff:float  ##角色攻击力增益,角色实际攻击力 = ATK_base*ATK_buff
@export var DEF_base:int  ##角色基础防御力,角色实际防御力 = DEF_base*DEF_buff
@export var DEF_buff:float  ##角色防御力增益,角色实际防御力 = DEF_base*DEF_buff
@export var buff_list:Array ## TODO 角色增益列表

@export var HP_UP:int ##HP恢复速度
@export var MP_UP:int ##MP恢复速度

enum CLAN{
	PLAYER, ## 玩家
	ENEMY,## 敌人
	NPC ## 其他中立role
}
