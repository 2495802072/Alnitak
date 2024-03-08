extends HSlider

@export var bus_index:int

func _ready():
	var v = AudioServer.get_bus_volume_db(bus_index)
	var rt = (v+24)/30
	value = rt*100
	drag_ended.connect(set_audio.bind())

func set_audio(_value_changed:bool):
	var rt = value/100
	var v = 30*rt-24
	if rt == 0:
		AudioServer.set_bus_mute(bus_index,true)
	else:
		AudioServer.set_bus_mute(bus_index,false)
		AudioServer.set_bus_volume_db(bus_index,v)
