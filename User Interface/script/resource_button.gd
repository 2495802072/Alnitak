class_name ResourceButton extends Button

signal sand_resouce(res:Resource) ##按下触发信号并发送按钮绑定的资源
var resource:Resource

func _ready():
	set_icon_alignment(HORIZONTAL_ALIGNMENT_CENTER) ##设置图标中心对齐
	if resource is ChartletConfig:
		icon = resource.get_icon()
		name = resource.resource_name
	elif resource is PlayerData:
		icon = resource.config.get_icon()
		name = resource.resource_name
	elif resource is WorldData:
		text = resource.world_name
		name = resource.world_name
	else:
		text = "损坏文件"

func _pressed():
	sand_resouce.emit(resource)

func get_resource_name() -> String:
	if resource:
		return resource.resource_name
	else:
		return "损坏文件"
