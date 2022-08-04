extends HBoxContainer

var character_dict = {
	"Amelie" : "res://images/amelie_270x360_no_mirror.png",
	"Wiggly" : "res://images/wigley_looking_left_230x307.png",
}


func _ready():
	for character in Global.party:
		var char_texture = TextureRect.new()
		char_texture.texture = load(character_dict[character])
		add_child(char_texture)
