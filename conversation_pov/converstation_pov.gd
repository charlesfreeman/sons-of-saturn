extends HBoxContainer

onready var avatar = $View/Control/Avatar
onready var amelie = load("res://conversation_pov/amelie_in_mirror.png")
onready var mirror = load("res://conversation_pov/clean_mirror.jpg")


func _ready():
	avatar.texture = amelie


func _on_Control_change_char(character):
	print(character)
	if character == "You":
		avatar.texture = mirror
