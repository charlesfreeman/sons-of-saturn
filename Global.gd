extends Node

var location = "res://sewer/just_stood_up/just_stood_up.tscn"
var region = "None"
# Amelie always assumed to be in party, never reason to check
var party = ["Wiggly"]
var scene_type = "TitleScreen"
var active_popup = false
var soundscape = "None"
var soundscapes = []
var dbrightness = 0.6
var cursor = "null"

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

onready var mag_glass = load("res://roaming_pov/images/mag_glass.png")
onready var cont_sym = load("res://roaming_pov/images/cont_arrow.png")
onready var pointer_up = load("res://roaming_pov/images/arrow_up_cursor.png")
onready var pointer_right = load("res://roaming_pov/images/arrow_right_cursor.png")
onready var pointer_down = load("res://roaming_pov/images/arrow_down_cursor.png")
onready var pointer_left = load("res://roaming_pov/images/arrow_left_cursor.png")

onready var cursors = {
	"null" : null,
	"mag_glass" : mag_glass,
	"cont_sym" : cont_sym,
	"pointer_up" : pointer_up,
	"pointer_right" : pointer_right,
	"pointer_down" : pointer_down,
	"pointer_left" : pointer_left,
}


func _ready():
	for c in Mds.get_children():
		soundscapes.append(c.get_name())

func set_cursor(new_cursor):
	Input.set_custom_mouse_cursor(cursors[new_cursor])
	cursor = new_cursor
	
func pause_cursor():
	Input.set_custom_mouse_cursor(null)
	
func unpause_cursor():
	Input.set_custom_mouse_cursor(cursors[cursor])

func change_song(new_song):
	TrackManager.play(new_song)

func stop_song():
	TrackManager.stop()
	
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
		inventory.append(item_name)
	else:
		print("Warning: %s already in inventory", item_name)

func remove_from_inv(item_name: String):
	if item_name in inventory:
		inventory.erase(item_name)
	else:
		print("Warning: cannot remove %s from inventory", item_name)

func get_region():
	return self.region
	
func set_region(map: String):
	self.region = map
	
func get_location():
	return self.location
	
func set_location(loc: String):
	self.location = loc
	
func set_scene_type(new_scene_type):
	self.scene_type = new_scene_type

func produce_save_dict():
	var save_dict = {
		"location" : location,
		"region" : region,
		"party" : party,
		"prog_flags" : prog_flags,
		"scene_type" : scene_type,
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
	scene_type = save_data["scene_type"]
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene(scene_type, options, options, general_options)
	
func check_save_exists():
	var sgame = File.new()
	return sgame.file_exists("user://savegame.save")
	
func reset_prog_flags():
	for key in prog_flags.keys():
		prog_flags[key] = false
	prog_flags["None"] = true
	
