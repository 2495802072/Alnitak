extends Button

@export var page:int

func _pressed():
	$"../../../Panel2/TabContainer".current_tab = page
	$"../../../..".selected()
