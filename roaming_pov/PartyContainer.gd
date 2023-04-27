extends HBoxContainer

var character_dict = {
	"Wiggly" : "res://conversation_pov/char_profiles/wiggly/wiggly_neutral.png",
	"Julia" : "res://conversation_pov/char_profiles/julia/julia_neutral.png"
}


func _ready():
	var char_texture_scene = load("res://roaming_pov/PartyMember.tscn")
	for character in Global.party:
		if character != "":
			var char_texture = char_texture_scene.instance()
			char_texture.rect_min_size.x = 359
			char_texture.texture = load(character_dict[character])
			add_child(char_texture)
