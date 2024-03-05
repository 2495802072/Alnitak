class_name GUIViewManager extends Node

@export var ViewConfigList:Array[GUIViewConfig] = []
@export var guiRoot:Control

var viewInstanceCount := 0
var viewInstanceMap := {}

var viewConfigMap := {}

func _ready():
	_build_view_config_map()
	
	G._get_view_manager().open_view("StartMenu")

func open_view(viewId:StringName) ->int:
	var config := _get_view_config(viewId)
	var instance := _get_new_view_instance_id()
	var prefab:PackedScene = config.prefab
	var view = prefab.instantiate() as BaseGUIView
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
	for config in ViewConfigList:
		if config == null or config.id.is_empty():
			continue
		viewConfigMap[config.id] = config
