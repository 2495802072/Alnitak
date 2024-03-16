class_name ResourceButton extends Button

signal _sand_resouce(res:Resource) ##按下触发信号并发送按钮绑定的资源
var resource:Resource

func _ready():
	if resource is ChartletConfig:
		icon = resource.icon

func _pressed():
	_sand_resouce.emit(resource)
