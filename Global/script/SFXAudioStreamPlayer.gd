extends AudioStreamPlayer

@export var SFXArray:Array[AudioStream] = []


func Audio_Play(index:int,begin:float = 0) -> void:
	stream = SFXArray[index]
	play(begin)
	pass
