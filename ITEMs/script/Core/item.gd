class_name Item extends Node

var item_owner:String #存储UID ,## TODO 上下建议一样，确认NPC的唯一方式后需要修改
var item_target #作用目标

func _using() -> void:
	pass

func _be_used() ->void:
	pass
