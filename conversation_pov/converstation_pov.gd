extends HBoxContainer

onready var avatar = $View/Control/Avatar
onready var amelie_alone = load("res://conversation_pov/amelie-bust-no-mirror.png")
onready var amelie_in_mirror = load("res://conversation_pov/clean-mirror-amelie-isolated.png")


func _ready():
	avatar.texture = amelie_alone


func _on_Control_change_char(character):
	print(character)
	if character == "You":
		avatar.texture = amelie_in_mirror
