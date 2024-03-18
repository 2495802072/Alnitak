extends BaseGUIView

signal make_decision(flag:bool)

@onready var alert_text:String
@onready var text_box:RichTextLabel = $CenterContainer/VBoxContainer/Panel/RichTextLabel as RichTextLabel
@onready var cancel_button:Button = $CenterContainer/VBoxContainer/HSplitContainer/Cancel as Button
@onready var view_manager:GUIViewManager = G._get_view_manager() as GUIViewManager

func _ready():
	alert_text = G._get_view_manager().get_alert_imformation() as String
	make_decision.connect(view_manager.set_alert_return.bind())

func _open():
	text_box.text = alert_text
	cancel_button.grab_focus()
	pass

func _on_cancel_pressed():
	make_decision.emit(false)
	_close_self()

func _on_enter_pressed():
	make_decision.emit(true)
	_close_self()

func _on_gui_input(event): ## 点击外围区域默认关闭，返回Cancel
	if event is InputEventMouseButton and event.button_index == 1:
		_on_cancel_pressed()
