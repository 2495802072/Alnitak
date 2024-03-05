class_name BaseGUIView extends Control

signal be_opened
signal be_closed
signal be_hided
signal be_showed
var config:GUIViewConfig
var viewInstanceID:int = -1


func open():
	be_opened.emit()
	_open()

func close():
	be_closed.emit()
	_close()

func be_hide():
	be_hided.emit()
	_be_hide()

func be_show():
	be_showed.emit()
	_be_show()

func _open():
	pass

func _close():
	pass

func _be_hide():
	pass

func _be_show():
	pass

func _close_self():
	G._get_view_manager().close_view(viewInstanceID)

func _hide_others():
	for InstanceId:int in G._get_view_manager().viewInstanceMap:
		if InstanceId != viewInstanceID:
			G._get_view_manager().hide_view(InstanceId)

func _show_others():
	for InstanceId:int in G._get_view_manager().viewInstanceMap:
		if InstanceId != viewInstanceID:
			G._get_view_manager().show_view(InstanceId)
