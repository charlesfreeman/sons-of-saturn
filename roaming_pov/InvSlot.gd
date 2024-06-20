extends TextureRect

var item_texture_paths = {
	"Jasper" : "res://conversation_pov/char_profiles/jasper/jasper_twisted.png",
	"Stimulants" : "res://roaming_pov/images/stimulant_bottle.png",
	"Key" : "res://roaming_pov/images/key_inventory.png",
	"Jasper + Giant Rat" : "res://roaming_pov/images/jasper_rat_together.png",
	"Giant Rat" : "res://roaming_pov/images/giant_rat.png",
	"Hand" : "res://roaming_pov/images/mom_hand_detached_item.png",
	"Stillbirth Certificate" : "res://roaming_pov/images/stillbirth_doc_item.png",
}

@onready var item = $Item


func _ready():
	pass


func set_item(item_name: String):
	item.texture = load(item_texture_paths[item_name])


func set_tooltip(name: String):
	item.tooltip_text = name
	
	
func clear_texture():
	item.texture = null
