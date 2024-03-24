extends BaseGUIView

@onready var world_name:LineEdit = $VBoxContainer/HSplitContainer/HSplitContainer/WorldName as LineEdit
@onready var world_seed:LineEdit = $VBoxContainer/HSplitContainer/HSplitContainer2/WorldSeed as LineEdit
@onready var difficult:Button = $VBoxContainer/HboxContainer/difficult as Button


var data:WorldData

func _ready():
	data = WorldData.new()

func _on_world_name_text_changed(new_name:String) -> void: ##设置世界名称
	data.world_name = new_name
	data.resource_name = new_name

func _on_world_seed_text_changed(new_text:String) -> void: ##设置世界种子
	data.world_seed = int(new_text)

func _on_back_pressed() -> void:
	G._get_view_manager().open_view("WorldSelect")
	_close_self()

func _on_create_pressed() -> void:
	if world_name.text == "":
		world_name.grab_focus()
	elif world_seed.text == "":
		world_seed.grab_focus()
	else:
		data.save_as_world()
		
		data.player_borth_position = Vector2i(7,7)
		
		_on_back_pressed()

func _on_difficult_pressed() -> void: ##修改世界难度
	match (difficult.text):
		"difficult:easy":
			difficult.text = "difficult:normal"
			data.difficult = WorldData.DIFFICULTIES.NORMAL
		"difficult:normal":
			difficult.text = "difficult:difficult"
			data.difficult = WorldData.DIFFICULTIES.DIFFICULT
		"difficult:difficult":
			difficult.text = "difficult:easy"
			data.difficult = WorldData.DIFFICULTIES.EASY
