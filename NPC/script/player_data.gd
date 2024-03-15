class_name PlayerData extends Resource

var player:PlayerBase

static func write_player_data(path:String,player:PlayerBase) -> PlayerData:
	var data:PlayerData = PlayerData.new()
	return data

static func get_player_data(path:String = "res://Data/player/") -> PlayerData:
	var data:PlayerData = PlayerData.new()
	return data
