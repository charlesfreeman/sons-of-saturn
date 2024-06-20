extends Control

@export var subject = ""
@export var scriptPath = "res://dialogue_system/conversations/test_scene.json" # (String, FILE, "*.json")
@export var backgroundPath = "res://images/looking_up_well_square.png" # (String, FILE, "*.png")
@export var sliverPath = "res://infirmary/morgue_convo/autopsy_table_sliver.png" # (String, FILE, "*.png")
@export var nextScenePath: String = "roaming_pov"
@export var nextLocation = "res://infirmary/post_office/PostOfficeMural.tscn" # (String, FILE, "*.tscn")
@export var tag_dict = {}
@export var tag_dict_sliver = {}
@export var fade_tag_dict = {}
@export var fade_tag_dict_sliver = {}
# might need to refactor to array if ever want to add more than one party mem
# following a convo
@export var new_party_mem = ""
@export var mem_to_remove = ""
@export var prog_flag = "None"
@export var song = "None"
@export var new_item = "None"
@export var new_item_2 = "None"
@export var remove_item = "None"
# if true, checks the value of prog_flag to see if played before.
# you must set prog_flag to some value to use this
@export var play_only_once = false
@export var wiggly_mode = false

@onready var avatar = $Convo/View/CanvasLayer/Avatar
@onready var background = $Convo/View
@onready var bg_sliver = $Convo/RightSideBG
@onready var dialogue_sys = $Convo/HBoxContainer/Dialogue
@onready var transition_screen = $Convo/TransitionScreen
@onready var convo = $Convo
@onready var esc_opts = $EscOpts
@onready var options = $Options
@onready var esc_opts_resume = $EscOpts/Node2D/Buttons/Resume
@onready var save = $Save
@onready var saveload = $SaveLoad
@onready var load_game_option = $SaveLoad/LoadGameOption
@onready var delete_game_option = $SaveLoad/DeleteGameOption
@onready var current_bg_path = backgroundPath


# need var to store tag so we can communicate between _on_Dialogue_tag and 
# _on_TransitionScreen_transitioned methods
var fade_tag

# var to store Amelie's current emotion, since this is handled differently
var amelie_emotion = "aneutral"
var wiggly_emotion = "wneutral"

# array to keep track of which tags already been emitted, so we might avoid
# playing the same effects repeatedly
var bg_tags_emitted = []

# for keeping track of if we need to swap av when subject removed
var subject_speaking = false


var amelie_profiles = {
	"aconfused" : "res://conversation_pov/char_profiles/amelie/amelie_confused.png",
	"adisgusted" : "res://conversation_pov/char_profiles/amelie/amelie_disgusted.png",
	"afuming" : "res://conversation_pov/char_profiles/amelie/amelie_fuming.png",
	"aguilty" : "res://conversation_pov/char_profiles/amelie/amelie_guilty.png",
	"aneutral" : "res://conversation_pov/char_profiles/amelie/amelie_neutral.png",
	"asad" : "res://conversation_pov/char_profiles/amelie/amelie_sad.png",
	"ashocked" : "res://conversation_pov/char_profiles/amelie/amelie_shocked.png",
	"auncertain" : "res://conversation_pov/char_profiles/amelie/amelie_uncertain.png",
}

var wiggly_tag_profiles = {
	"whalf_smile" : "res://conversation_pov/char_profiles/wiggly/wiggly_half_smile.png",
	"wlaughing" : "res://conversation_pov/char_profiles/wiggly/wiggly_laughing.png",
	"wlooking_to_side" : "res://conversation_pov/char_profiles/wiggly/wiggly_looking_to_side.png",
	"wsad" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
	"wskeptical" : "res://conversation_pov/char_profiles/wiggly/wiggly_skeptical.png",
	"wsurprised" : "res://conversation_pov/char_profiles/wiggly/wiggly_surprised.png",
	"wwincing" : "res://conversation_pov/char_profiles/wiggly/wiggly_wincing.png",
	"wthinking" : "res://conversation_pov/char_profiles/wiggly/wiggly_thinking.png",
	"wneutral" : "res://conversation_pov/char_profiles/wiggly/wiggly_neutral.png",
}

var wiggly_profiles = {
	"half_smile" : "res://conversation_pov/char_profiles/wiggly/wiggly_half_smile.png",
	"laughing" : "res://conversation_pov/char_profiles/wiggly/wiggly_laughing.png",
	"looking_to_side" : "res://conversation_pov/char_profiles/wiggly/wiggly_looking_to_side.png",
	"sad" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
	"skeptical" : "res://conversation_pov/char_profiles/wiggly/wiggly_skeptical.png",
	"surprised" : "res://conversation_pov/char_profiles/wiggly/wiggly_surprised.png",
	"wincing" : "res://conversation_pov/char_profiles/wiggly/wiggly_wincing.png",
	"thinking" : "res://conversation_pov/char_profiles/wiggly/wiggly_thinking.png",
	"neutral" : "res://conversation_pov/char_profiles/wiggly/wiggly_neutral.png",
}

var julia_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/julia/julia_neutral.png",
	"amused" : "res://conversation_pov/char_profiles/julia/julia_amused.png",
	"concerned" : "res://conversation_pov/char_profiles/julia/julia_concerned.png",
	"lost_in_thought" : "res://conversation_pov/char_profiles/julia/julia_lost_in_thought.png",
	"reminiscing" : "res://conversation_pov/char_profiles/julia/julia_reminiscing.png",
	"sly" : "res://conversation_pov/char_profiles/julia/julia_sly.png",
	"suspicious" : "res://conversation_pov/char_profiles/julia/julia_suspiscious.png",
	"thinking" : "res://conversation_pov/char_profiles/julia/julia_thinking.png",
	"worried" : "res://conversation_pov/char_profiles/julia/julia_worried.png",
}

var jasper_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/jasper/jasper_neutral.png",
	"head_tilted" : "res://conversation_pov/char_profiles/jasper/jasper_head_tilted.png",
	"looking_forward" : "res://conversation_pov/char_profiles/jasper/jasper_looking_forward.png",
	"surprised" : "res://conversation_pov/char_profiles/jasper/jasper_surprised.png",
	"sad" : "res://conversation_pov/char_profiles/jasper/jasper_sad.png",
	"turned_away" : "res://conversation_pov/char_profiles/jasper/jasper_turned_away.png",
	"twisted" : "res://conversation_pov/char_profiles/jasper/jasper_twisted.png",
	"thinking" : "res://conversation_pov/char_profiles/jasper/jasper_thinking.png",
	"voice" : "res://conversation_pov/char_profiles/jasper/voice_headshot.png",
	"malformed_lump" : "res://conversation_pov/char_profiles/jasper/malformed_lump_headshot.png",
}

var misc_profiles = {
	"Tann" : "res://conversation_pov/char_profiles/misc/tann_profile.png",
	"Ansel" : "res://conversation_pov/char_profiles/misc/ansel_profile.png",
	"Vera" : "res://conversation_pov/char_profiles/misc/vera_profile.png",
	"Leslie" : "res://conversation_pov/char_profiles/misc/leslie_in_mirror.png",
	"Robert" : "res://conversation_pov/char_profiles/misc/robert_in_mirror.png",
	"Frost" : "res://conversation_pov/char_profiles/misc/frost_profile.png",
	"Giant Rat" : "res://conversation_pov/char_profiles/misc/giant_rat_profile.png"
}

# need to track state of subjects for changing profiles mid convo
var current_av = "Amelie"
var previous_av = "Amelie"

signal tag(tag)


func _ready():
	Global.set_cursor("null")
	Global.change_song(song)
	Global.set_scene_type(get_tree().current_scene.name)
	dialogue_sys.wiggly_mode = self.wiggly_mode
	dialogue_sys.set_script_path(scriptPath)
	dialogue_sys.set_next_scene_path(nextScenePath)
	dialogue_sys.set_mem_to_add(new_party_mem)
	dialogue_sys.set_mem_to_remove(mem_to_remove)
	dialogue_sys.set_next_location(nextLocation)
	dialogue_sys.set_prog_flag(prog_flag)
	dialogue_sys.init()
	change_background(backgroundPath)
	change_background_sliver(sliverPath)
	if new_item != "None":
		Global.add_to_inv(new_item)
	if new_item_2 != "None":
		Global.add_to_inv(new_item_2)
	if remove_item != "None":
		Global.remove_from_inv(remove_item)


func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		if load_game_option.visible:
			load_game_option.visible = false
			saveload.enable_savegames()
		elif delete_game_option.visible:
			delete_game_option.visible = false
			saveload.enable_savegames()
		elif not esc_opts.visible and not options.visible and not saveload.visible:
			self._pause_game()
		elif esc_opts.visible:
			self._unpause_game()
		elif options.visible:
			options.visible = false
			esc_opts.visible = true
		elif saveload.visible:
			saveload.visible = false
			esc_opts.visible = true


func _pause_game():
	convo.modulate = Color(0.6, 0.6, 0.6, 1)
	esc_opts.visible = true
	esc_opts_resume.grab_focus()
	
	
func _unpause_game():
	convo.modulate = Color(1, 1, 1, 1)
	esc_opts.visible = false
	
	
# assume this is called every time either character or emotion changes
# dialogue sys does labor of tracking state
func _on_dialogue_change_char(character, emotion):
	if character != "Narrator":
		if character != subject:
			subject_speaking = false
			load_texture(character, emotion)
			avatar.brighten()
		else:
			subject_speaking = true
			avatar.darken()
	else:
		avatar.darken()


func load_texture(character, emotion):
	match character:
		"Amelie":
			avatar.texture = load(amelie_profiles[amelie_emotion])
		"WigglyTag":
			avatar.texture = load(wiggly_tag_profiles[wiggly_emotion])
		"Wiggly":
			avatar.texture = load(wiggly_profiles[emotion])
		"Jasper":
			avatar.texture = load(jasper_profiles[emotion])
		"Julia":
			avatar.texture = load(julia_profiles[emotion])
		_:
			if character in misc_profiles.keys():
				avatar.texture = load(misc_profiles[character])
	previous_av = current_av
	current_av = character
			
			
func _remove_subject():
	if subject_speaking:
		load_texture(subject, "neutral")
		subject_speaking = false
	subject = ""


func _add_subject(sub: String):
	subject = sub
	# if new subject currently displayed, load the previous av in neutral
	if sub == current_av:
		load_texture(previous_av, "neutral")


func change_background(res_path):
	var new_background = load(res_path)
	background.texture = new_background
	current_bg_path = res_path


func change_background_sliver(res_path):
	var new_background_sliver = load(res_path)
	bg_sliver.texture = new_background_sliver


func _on_dialogue_tag(tags):
	for tag in tags:
		emit_signal("tag", tag)
		get_tree().call_group("CharacterRects", "appear_disappear", tag)
		if not tag in bg_tags_emitted:
			if tag in tag_dict.keys():
				if tag_dict[tag] != current_bg_path:
					change_background(tag_dict[tag])
					change_background_sliver(tag_dict_sliver[tag])
#					if not tag.ends_with("_repeat"):
#						bg_tags_emitted.append(tag)
			elif tag in fade_tag_dict.keys():
				if fade_tag_dict[tag] != current_bg_path:
					fade_tag = tag
					transition_screen.transition()
#					if not tag.ends_with("_repeat"):
#						bg_tags_emitted.append(tag)

			# store amelie's emotion in a local variable since it isn't to be
			# used immediately
			elif tag in amelie_profiles.keys():
				amelie_emotion = tag
			elif tag in wiggly_tag_profiles.keys():
				wiggly_emotion = tag
				
			elif tag == "add_wiggly":
				self._add_subject("Wiggly")
			elif tag == "add_julia":
				self._add_subject("Julia")
			elif tag == "add_dead_cat":
				self._add_subject("Dead Cat")
			elif tag == "add_giant_rat":
				self._add_subject("Giant Rat")
			elif tag == "remove_subject":
				self._remove_subject()

			elif tag in TrackManager.songs:
				Global.change_song(tag)
			elif tag == "stop_song":
				Global.stop_song()
				
			get_tree().call_group("convo_sound_effect", "check_tag", tag)


func _on_TransitionScreen_transitioned():
	change_background(fade_tag_dict[fade_tag])
	change_background_sliver(fade_tag_dict_sliver[fade_tag])
	current_bg_path = fade_tag_dict[fade_tag]


func _on_Resume_pressed():
	self._unpause_game()


func _on_Save_pressed():
	# TODO replace use of save symbol
	esc_opts.visible = false
	saveload.visible = true


func _on_Exit_pressed():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("TitleScreen", options, options, general_options)


func _on_exit_button_pressed():
	options.visible = false
	esc_opts.visible = true


func _on_options_pressed():
	esc_opts.visible = false
	options.visible = true


func _on_saveload_exit_button_pressed():
	saveload.visible = false
	esc_opts.visible = true
