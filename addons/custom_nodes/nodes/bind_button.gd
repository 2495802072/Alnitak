## 专门用于构造游戏设置的“按键绑定”
extends Button

## 发送绑定键更改信号 用于修改[InputMap]中输入映射
signal bind_changed()

var flag:bool = false
## action的名称需要在[InputMap]可以找到
@export var action:String
## [InputEventWithModifiers]能检测键鼠，以及组合键
@export var bindkey:InputEventWithModifiers


func _enter_tree():
	if action != "" and InputMap.has_action(action):
		var array = InputMap.action_get_events(action)
		bindkey = array[0]
	button_up.connect(click.bind())

##初始化
func _ready():
	reset_text()

func click():
	flag = true
	disabled = true
	pass

func _input(event):
	if flag:
		if action == "" :
			print("BindButton使用必须存在action")
			flag = false
			disabled = false
			
		elif InputMap.has_action(action) and event is InputEventWithModifiers:
			if not event is InputEventMouseMotion: #检测是否在键鼠按键范围内
				#给予组合键提示
				if event is InputEventKey:
					if event.keycode == 4194325:
						text = "shift+"
					if event.keycode == 4194326:
						text = "ctrl+"
					if event.keycode == 4194328:
						text = "alt+"
				
				if event.is_released():
					var old_bind_key:InputEventWithModifiers = bindkey
					bindkey = event
					update_inputmap(old_bind_key,bindkey)
					bind_changed.emit() #触发信号
					flag = false
					disabled = false
			
		else:
			print("action无法在[InputMap]中找到")
			flag = false
			disabled = false
			

func update_inputmap(oldkey:InputEventWithModifiers,newkey:InputEventWithModifiers):
	var dir = ProjectSettings.get_setting("input/"+action)
	if newkey:
		if oldkey: #具备旧的按键绑定(更换)
			dir["events"].erase(oldkey)
			dir["events"].append(newkey)
		else: #不具备(添加)
			dir["events"].append(newkey)
	else: #删除
		dir["events"].erase(oldkey)
	ProjectSettings.set_setting("input/123",dir)
	reset_text()

func reset_text():
	if bindkey != null :
		text = bindkey.as_text()
	else:
		text = "(null)"
