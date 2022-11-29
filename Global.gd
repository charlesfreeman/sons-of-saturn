extends Node

var location = "res://infirmary/overgrowth_pink_hallway/overgrowth_pink_hallway.tscn"
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
	"wiggly_reunite" : false,
	"None" : true,
	"False" : false,
}
var song = "None"
var soundscape = "None"
var songs = []
var soundscapes = []

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
