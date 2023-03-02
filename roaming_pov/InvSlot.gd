extends TextureRect

var item_texture_paths = {
	"Jasper" : "res://conversation_pov/char_profiles/jasper/jasper_headshot_feathered.png",
}

onready var item = $Item


func _ready():
	pass


func set_item(item_name: String):
	item.texture = load(item_texture_paths[item_name])
