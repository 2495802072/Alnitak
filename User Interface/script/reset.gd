extends Button

@export var key:InputEventWithModifiers

func _pressed():
	var oldkey = $"..".bindkey
	$"..".bindkey = key
	$"..".update_inputmap(oldkey,key)
