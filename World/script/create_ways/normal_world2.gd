class_name NormalWorld extends WorldCreateWays

var rule:= WorldCreateWays.RULES.CREATED

func _create_block(_chunk_id:Vector2i,_block_vector:Vector2i,_noise_seed:int,_chunk_size:Vector2i) -> bool:
	var noise1:FastNoiseLite = FastNoiseLite.new()
	var noise2:FastNoiseLite = FastNoiseLite.new()
	noise1.set_seed(_noise_seed)
	noise2.set_seed(_noise_seed-1)
	var noise_vector:Vector2i = _chunk_id*_chunk_size+_block_vector
	if noise1.get_noise_2dv(noise_vector)*noise1.get_noise_2dv(noise_vector)\
	 < noise2.get_noise_2dv(noise_vector)*noise2.get_noise_2dv(noise_vector):
		return true
	else:
		return false
