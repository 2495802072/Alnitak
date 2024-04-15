## 平坦世界
class_name PlanarizationWorld extends WorldCreateWays

var rule:= WorldCreateWays.RULES.CREATED

func _create_block(_chunk_id:Vector2i,_block_vector:Vector2i,_noise_seed:int,_chunk_size:Vector2i) -> bool:
	if _chunk_id.y > 1:
		return true
	else:
		return false
