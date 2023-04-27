extends Node

var location = "res://sewer/just_stood_up/just_stood_up.tscn"
var region = "None"
# Amelie always assumed to be in party, never reason to check
var party = ["Wiggly"]
var active_popup = false
var song = "None"
var soundscape = "None"
var songs = []
var soundscapes = []
var dbrightness = 0.6

var prog_flags = {
	"overgrowth_pink_hallway" : false,
	"vera_office_convo" : false,
	"tann_office_convo" : false,
	"trash_chute_convo" : false,
	"cell_grate_convo" : false,
	"isolation_cells" : false,
	"door_open_popup" : false,
	"washing_machine_trio" : false,
	"julia_first_convo" : false,
	"medicine_cabinet_inspection" : false,
	"crib_overlook_convo" : false,
	"front_desk" : false,
	"inspection_hallway" : false,
	"wiggly_reunite" : false,
	"None" : true,
	"False" : false,
}

# keep track of what inventory player has globally, local scripts in charge of 
# loading and displaying the corresponding textures
var inventory = ["Jasper"]

func _ready():
	for c in Mdm.get_children():
		songs.append(c.get_name())
	for c in Mds.get_children():
		soundscapes.append(c.get_name())

func change_song(song):
	if song == "None":
		if Global.song != "None":
			self.stop_song()
	else:
		if Global.song == "None":
			Mdm.init_song(song)
			Mdm.play(song)
		else:
			Mdm.queue_beat_transition(song)
		Global.song = song

func stop_song():
	Mdm.stop(Global.song)
	Global.song = "None"
	
func change_soundscape(scape_name):
	if scape_name == "Stop":
		if Global.soundscape != "None":
			self.stop_soundscape()
	elif scape_name != "None" and scape_name != Global.soundscape:
		if Global.soundscape != "None":
			stop_soundscape()
		var ss = Mds.get_node(scape_name)
		ss.play()
		Global.soundscape = scape_name
			
func stop_soundscape():
	var ss = Mds.get_node(Global.soundscape)
	ss.stop()
	Global.soundscape = "None"

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

func add_to_inv(item_name: String):
	if not item_name in inventory:
		party.append(item_name)
	else:
		print("Warning: %s already in party", item_name)

func remove_from_inv(item_name: String):
	if item_name in party:
		party.erase(item_name)
	else:
		print("Warning: cannot remove %s from party", item_name)

func get_region():
	return self.region
	
func set_region(map: String):
	self.region = map

func produce_save_dict():
	var save_dict = {
		"location" : location,
		"region" : region,
		"party" : party,
		"prog_flags" : prog_flags,
	}
	return save_dict
	
func save_game():
	var sgame = File.new()
	sgame.open("user://savegame.save", File.WRITE)
	var save_data = produce_save_dict()
	sgame.store_line(to_json(save_data))
	sgame.close()
	
func load_game():
	var sgame = File.new()
	if not sgame.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	sgame.open("user://savegame.save", File.READ)
	var save_data = parse_json(sgame.get_line())
	print(save_data.keys())
	location = save_data["location"]
	region = save_data["region"]
	party = save_data["party"]
	prog_flags = save_data["prog_flags"]
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("roaming_pov", options, options, general_options)
	
func check_save_exists():
	var sgame = File.new()
	return sgame.file_exists("user://savegame.save")
	
