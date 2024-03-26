extends Camera2D

@export var player:Node2D
@export var target1:Node2D
@export var target2:Node2D
@export var focal_point:Vector2 ##相机焦点中心,相机跟随点
@export var smoothing_speed:float = 5.0 ##相机平滑速度
@export var mode := MODES.NONE ##默认相机为无目标模式

enum MODES{
	NONE,##无目标
	PLAYER_TARGET,##仅玩家目标模式
	ONE_TARGET,## 单目标模式
	TWO_TARGET## 双目标模式
}

func _process(delta):
	if not focal_point:
		return
	if mode == MODES.NONE:
		focal_point = Vector2(0,0)
	elif mode == MODES.PLAYER_TARGET:
		focal_point = player.position
	elif mode == MODES.ONE_TARGET:
		focal_point = target1.position
	else:
		if (target2.position-target1.position).length_squared() > 1920*1920: ## TODO 这个值还需要平衡
			print("目标之间距离过远")
		focal_point = (target1.position + target2.position)/2
	var new_position = position.lerp(focal_point, smoothing_speed* delta)##线性平滑
	position = new_position

func player_exit():
	change_mode_to(0)

func change_mode_to(index:int) -> void:
	match(index):
		0:
			mode = MODES.NONE
		1:
			mode = MODES.PLAYER_TARGET
		2:
			mode = MODES.ONE_TARGET
		3:
			mode = MODES.TWO_TARGET

func focal_player() -> void:
	if player:
		focal_point = player.position
	pass
