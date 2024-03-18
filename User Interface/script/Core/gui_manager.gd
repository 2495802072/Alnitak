class_name GUIViewManager extends Node

signal  alert_return_update()
var alert_imformation:String = ""
var alert_return:bool = false

@export var ViewConfigList:Array[GUIViewConfig] = []
@export var guiRoot:Control

var viewConfigMap := {}

var viewInstanceCount := 0
var viewInstanceMap := {}

var has_language:bool = FileAccess.file_exists(G.language_file)

func _ready():
	_build_view_config_map()
	G._get_view_manager().open_view("StartMenu")
	if not has_language:
		G._get_view_manager().open_view("SettingsMenu")

func open_view(viewId:StringName) ->int:
	var config := _get_view_config(viewId)
	var instance := _get_new_view_instance_id()
	var prefab:PackedScene = config.prefab
	var view:BaseGUIView = prefab.instantiate()
	view.config = config
	view.viewInstanceID = instance
	viewInstanceMap[instance] = view
	guiRoot.add_child(view)
	view.open()
	return instance

func close_view(viewInstanceId:int):
	var view := _get_view_by_instance(viewInstanceId)
	view.close()
	viewInstanceMap.erase(viewInstanceId)
	view.queue_free()

func hide_view(viewInstanceId:int):
	var view := _get_view_by_instance(viewInstanceId)
	view.be_hide()
	view.hide()

func show_view(viewInstanceId:int):
	var view := _get_view_by_instance(viewInstanceId)
	view.be_hide()
	view.show()

func _get_view_config(viewId:StringName) -> GUIViewConfig:
	return viewConfigMap[viewId]

func _get_new_view_instance_id() -> int:
	var t:int = viewInstanceCount
	viewInstanceCount += 1
	return t

func _get_view_by_instance(viewInstanceId:int) -> BaseGUIView:
	return viewInstanceMap[viewInstanceId]

func _build_view_config_map():
	for config:GUIViewConfig in ViewConfigList:
		if config == null or config.id.is_empty():
			continue
		viewConfigMap[config.id] = config

func jump_alert(imformation:String) -> bool:
	alert_imformation = imformation
	alert_return = false
	G._get_view_manager().open_view("Alert")
	await alert_return_update
	return alert_return

func get_alert_imformation() -> String:
	return alert_imformation

func set_alert_return(flag:bool) -> void:
	alert_return = flag
	alert_return_update.emit()
