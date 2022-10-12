extends Node

var location = "res://sewer/just_stood_up/just_stood_up.tscn"
# Amelie always assumed to be in party, never reason to check
var party = ["Wiggly"]
var active_popup = false
var prog_flags = {
	"overgrowth_pink_hallway" : false,
	"vera_office_convo" : false,
	"tann_office_convo" : false,
	"trash_chute_convo" : false,
	"cell_grate_convo" : false,
	"door_open_popup" : false,
	"julia_first_convo" : false,
	"medicine_cabinet_inspection" : false,
	"None" : true,
	"False" : false,
}

func _ready():
	pass

func flip_prog_flag(flag: String):
	prog_flags[flag] = true
	
func get_prog_flag(flag: String):
	return prog_flags[flag]

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

func produce_save_dict():
	var save_dict = {
		"location" : location,
		"party" : party
	}
	return save_dict
	
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	var save_data = produce_save_dict()
	save_game.store_line(to_json(save_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	var save_data = parse_json(save_game.get_line())
	print(save_data.keys())
	location = save_data["location"]
	party = save_data["party"]
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("roaming_pov", options, options, general_options)
