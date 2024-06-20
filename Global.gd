extends Node

var location = "res://childrens_ward/empty_room/empty_room.tscn"
var region = "None"
# Amelie always assumed to be in party, never reason to check
var party = ["Wiggly"]
var scene_type = "TitleScreen"
var active_popup = false
var retro_font_mode = false
var dbrightness = 0.6
var cursor = "null"
var font_size = 48
var footstep_vol = 0
var typewriter_vol = 0
var sound_effect_vol = 0
var sound_track_vol = 0
var brightness = 1
var contrast = 1
var saturation = 1

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
	"vera_new_office" : false,
	"theater_convo" : false,
	"abortion_convo" : false,
	"custody_convo" : false,
	"julia_room" : false,
	"julia_room_convo" : false,
	"fallen_through_roof" : false,
	"scientist_computer_convo" : false,
	"scientist_computer_convo_2" : false,
	"double_hall_entered" : false,
	"angela_room_convo" : false,
	"vera_final_convo" : false,
	"not_visited_vera" : true,
	"safe_convo" : false,
	"finished_game" : false,
	"None" : true,
	"False" : false,
}

# keep track of what inventory player has globally, local scripts in charge of 
# loading and displaying the corresponding textures
var inventory = ["Jasper"]

@onready var mag_glass = load("res://roaming_pov/images/mag_glass.png")
@onready var cont_sym = load("res://roaming_pov/images/cont_arrow.png")
@onready var pointer_up = load("res://roaming_pov/images/arrow_up_cursor.png")
@onready var pointer_right = load("res://roaming_pov/images/arrow_right_cursor.png")
@onready var pointer_down = load("res://roaming_pov/images/arrow_down_cursor.png")
@onready var pointer_left = load("res://roaming_pov/images/arrow_left_cursor.png")

@onready var cursors = {
	"null" : null,
	"mag_glass" : mag_glass,
	"cont_sym" : cont_sym,
	"pointer_up" : pointer_up,
	"pointer_right" : pointer_right,
	"pointer_down" : pointer_down,
	"pointer_left" : pointer_left,
}


func _ready():
	pass

func set_font_size(new_font_size):
	self.font_size = new_font_size

func set_footstep_vol(new_footstep_vol):
	self.footstep_vol = new_footstep_vol

func set_typewriter_vol(new_typewriter_vol):
	self.typewriter_vol = new_typewriter_vol

func set_sound_effect_vol(new_sound_effect_vol):
	self.sound_effect_vol = new_sound_effect_vol

func set_sound_track_vol(new_sound_track_vol):
	self.sound_track_vol = new_sound_track_vol

func set_brightness(new_brightness):
	self.brightness = new_brightness
	
func set_contrast(new_contrast):
	self.contrast = new_contrast
	
func set_saturation(new_saturation):
	self.saturation = new_saturation
	
func set_cursor(new_cursor):
	Input.set_custom_mouse_cursor(cursors[new_cursor])
	cursor = new_cursor
	
# for resetting the cursor upon exiting ClickToSearch and PopUps (simply 
# setting null overwrites the cursor of popups in some cases)
func search_release_cursor():
	if cursor == "mag_glass":
		set_cursor("null")

# same but for ClickToEnter
func enter_release_cursor():
	if cursor.begins_with("pointer"):
		set_cursor("null")

# for the pause screen in roaming_pov
func pause_cursor():
	Input.set_custom_mouse_cursor(null)
	
func unpause_cursor():
	Input.set_custom_mouse_cursor(cursors[cursor])

func change_song(new_song):
	TrackManager.play(new_song)

func stop_song():
	TrackManager.stop()
	
func flip_prog_flag(flag: String):
	prog_flags[flag] = true
	
func negate_prog_flag(flag: String):
	prog_flags[flag] = false
	
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
	
func set_region_enabled(map: String):
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
		"inventory" : inventory,
		"scene_type" : scene_type,
		"font_size" : font_size,
		"footstep_vol" : footstep_vol,
		"typewriter_vol" : typewriter_vol,
		"sound_effect_vol" : sound_effect_vol,
		"sound_track_vol" : sound_track_vol,
		"brightness" : brightness,
		"contrast" : contrast,
		"saturation" : saturation,
	}
	return save_dict
	
func autosave():
	var sgame = FileAccess.open("user://sonsofsaturn.save", FileAccess.WRITE)
	var save_data = produce_save_dict()
	sgame.store_line(JSON.stringify(save_data))
	sgame.close()
	
func save_game():
	print("saving game")
	var time = Time.get_datetime_string_from_system()
	var savename = "user://" + "sos_" + region + "_" + time.replace(":", "_") + ".save"
	print("savename: ", savename)
	var sgame = FileAccess.open(savename, FileAccess.WRITE)
	var save_data = produce_save_dict()
	sgame.store_line(JSON.stringify(save_data))
	sgame.close()
	
func load_game(savegame_string):
	if not check_save_exists(savegame_string):
		return # Error! We don't have a save to load.
	var sgame = FileAccess.open(savegame_string, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(sgame.get_line())
	var save_data = test_json_conv.get_data()
	print(save_data.keys())
	location = save_data["location"]
	region = save_data["region"]
	party = save_data["party"]
	prog_flags = save_data["prog_flags"]
	if save_data.has("inventory"):
		inventory = save_data["inventory"]
	scene_type = save_data["scene_type"]
	font_size = save_data["font_size"]
	footstep_vol = save_data["footstep_vol"]
	typewriter_vol = save_data["typewriter_vol"]
	sound_effect_vol = save_data["sound_effect_vol"]
	sound_track_vol = save_data["sound_track_vol"]
	brightness = save_data["brightness"]
	contrast = save_data["contrast"]
	saturation = save_data["saturation"]
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene(scene_type, options, options, general_options)
	
func delete_save(sg_to_delete):
	var dir = DirAccess.open("user://")
	dir.remove(sg_to_delete)
	
func check_save_exists(savegame_string):
	return FileAccess.file_exists(savegame_string)
	
func reset_prog_flags():
	for key in prog_flags.keys():
		prog_flags[key] = false
	prog_flags["None"] = true
	prog_flags["not_visited_vera"] = true
	
