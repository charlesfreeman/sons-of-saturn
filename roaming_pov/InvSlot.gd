extends TextureRect

var item_texture_paths = {
	"Jasper" : "res://conversation_pov/char_profiles/jasper/jasper_twisted.png",
	"Stimulants" : "res://roaming_pov/images/stimulant_bottle.png",
	"Key" : "res://roaming_pov/images/key_inventory.png",
}

@onready var item = $Item


func _ready():
	pass


func set_item(item_name: String):
	item.texture = load(item_texture_paths[item_name])


func set_tooltip(name: String):
	item.tooltip_text = name
