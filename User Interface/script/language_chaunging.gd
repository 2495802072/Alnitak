extends VBoxContainer

var languages:Array = TranslationServer.get_loaded_locales()
var dictionary := {
	"English":"English",
	"Chinese":"简体中文",
	"German":"Deutsch",
	"Spanish":"Español",
	"French":"Français",
	"Italian":"Italiano"
}

func _ready():
	if languages:
		for language in languages:
			var button = ClassDB.instantiate("Button")
			button.name = language
			button.text = dictionary[TranslationServer.get_language_name(language)]
			button.pressed.connect(G._change_language.bind(button.name))
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			$GridContainer.add_child(button)
	pass 
