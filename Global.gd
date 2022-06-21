extends Node

var location = "res://sewer/just_stood_up/just_stood_up.tscn"
var party = ["Rando"]

func _ready():
	pass
	
func add_to_party(char_name: String):
	if not char_name in party:
		party.append(char_name)
	else:
		print("Warning: %s already in party", char_name)

func remove_from_party(char_name: String):
	if char_name in party:
		party.erase(char_name)
	else:
		print("Warning: cannot remove %s from party", char_name)

