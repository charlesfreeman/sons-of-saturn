extends HBoxContainer

var character_dict = {
	"Wiggly" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
}


func _ready():
	var char_texture_scene = load("res://roaming_pov/PartyMember.tscn")
	for character in Global.party:
		if character != "":
			print("Character: ", character)
			var char_texture = char_texture_scene.instance()
			char_texture.rect_min_size.x = 359
			char_texture.texture = load(character_dict[character])
			add_child(char_texture)
