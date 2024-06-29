extends AudioStreamPlayer

@export var BGMArray:Array[AudioStream] = []


func AudioPlay(index:int,begin:float = 0) -> void:
	stream = BGMArray[index]
	play(begin)
	pass
