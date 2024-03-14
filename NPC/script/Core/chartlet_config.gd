class_name ChartletConfig extends Resource

@export var name:StringName
@export var collision_shape:Shape2D
@export var sprit_frames:SpriteFrames

@export var icon:Texture2D

func _get_collision_size() -> Rect2:
	return collision_shape.get_rect()
