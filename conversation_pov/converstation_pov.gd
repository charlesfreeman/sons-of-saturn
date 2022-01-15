extends HBoxContainer

onready var avatar = $View/Control/Avatar
var amelie_alone = "res://conversation_pov/amelie-bust-no-mirror.png"
var amelie_in_mirror = "res://conversation_pov/clean-mirror-amelie-isolated.png"
var wigley = "res://conversation_pov/wigley_looking_left_cropped_filtered.png"

var char_textures = {
	"amelie": amelie_alone, 
	"None": amelie_in_mirror,
	"You": amelie_in_mirror, 
	"Wigley": wigley, 
	"Ferryman": wigley,
}


func _ready():
	avatar.texture = load(amelie_in_mirror)


func _on_Control_change_char(character):
	if character != "Voice":
		avatar.texture = load(char_textures[character])
