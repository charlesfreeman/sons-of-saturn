extends HBoxContainer

export var subject = ""
export(String, FILE, "*.json") var scriptPath = "res://dialogue_system/conversations/test_scene.json"
export(String, FILE, "*.png") var backgroundPath = "res://images/looking_up_well_square.png"
export(String, FILE, "*.png") var sliverPath = "res://infirmary/morgue_convo/autopsy_table_sliver.png"
export(String, FILE) var soundscapePath = "res://sounds/545664__nox-sound__ambiance-stream-sewer-reverb-small-loop-stereo-dr05.wav"
export(String) var nextScenePath = "roaming_pov"
export(String, FILE, "*.tscn") var nextLocation = "res://infirmary/post_office/PostOfficeMural.tscn"
export var tag_dict = {}
export var tag_dict_sliver = {}
export var fade_tag_dict = {}
export var fade_tag_dict_sliver = {}
# might need to refactor to array if ever want to add more than one party mem
# following a convo
export var new_party_mem = ""
export var mem_to_remove = ""
export var prog_flag = "None"
export var song = "None"
export var soundscape = "None"
# if true, checks the value of prog_flag to see if played before.
# you must set prog_flag to some value to use this
export var play_only_once = false

onready var avatar = $View/CanvasLayer/Avatar
onready var background = $View
onready var bg_sliver = $RightSideBG
onready var dialogue_sys = $HBoxContainer/Dialogue
onready var current_bg_path = backgroundPath
var amelie = "aneutral"
var wiggly = "wneutral"
var julia = "jneutral"
var jasper = "jasneutral"
var voice = "voice"
var malformed_lump = "malformed_lump"
var current_char = "You"


# need var to store tag so we can communicate between _on_Dialogue_tag and 
# _on_TransitionScreen_transitioned methods
var fade_tag

# array to keep track of which tags already been emitted, so we might avoid
# playing the same effects repeatedly
var bg_tags_emitted = []

# for mapping speaking char to variable names
var char_textures = {
	# not sure these two are needed anymore
	"None": amelie,
	"You": amelie, 
	"Wiggly": wiggly, 
	"Ferryman": wiggly,
	"Julia": julia,
	"Frail Woman": julia,
	"Jasper": jasper,
	"Malformed Lump": malformed_lump,
	"Voice": voice,
}

var char_profiles = {
	"adisgust" : "res://conversation_pov/char_profiles/amelie/amelie_disgusted.png",
	"afuming" : "res://conversation_pov/char_profiles/amelie/amelie_fuming.png",
	"aguilty" : "res://conversation_pov/char_profiles/amelie/amelie_guilty.png",
	"aneutral" : "res://conversation_pov/char_profiles/amelie/amelie_headshot_feathered.png",
	"aquestioning" : "res://conversation_pov/char_profiles/amelie/amelie_questioning.png",
	"asad" : "res://conversation_pov/char_profiles/amelie/amelie_sad.png",
	"atakenaback" : "res://conversation_pov/char_profiles/amelie/amelie_taken_aback.png",
	"auncertain" : "res://conversation_pov/char_profiles/amelie/amelie_uncertain.png",
	"whalfsmile" : "res://conversation_pov/char_profiles/wiggly/wiggly_half_smiling.png",
	"wlaugh" : "res://conversation_pov/char_profiles/wiggly/wiggly_laughing.png",
	"wsad" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
	"wskeptic" : "res://conversation_pov/char_profiles/wiggly/wiggly_skeptical.png",
	"wsurprise" : "res://conversation_pov/char_profiles/wiggly/wiggly_surprised.png",
	"wwincing" : "res://conversation_pov/char_profiles/wiggly/wiggly_wincing.png",
	"wneutral" : "res://conversation_pov/char_profiles/wiggly/wiggly_feathered_closedin.png",
	"jneutral" : "res://conversation_pov/char_profiles/julia/julia_placeholder.png",
	"jasneutral" : "res://conversation_pov/char_profiles/jasper/jasper_headshot_feathered.png",
	"voice" : "res://conversation_pov/char_profiles/jasper/voice_headshot.png",
	"malformed_lump" : "res://conversation_pov/char_profiles/jasper/malformed_lump_headshot.png",
}

signal tag(tag)


func _ready():	
	if prog_flag != "None":
		Global.flip_prog_flag(prog_flag)
	Global.change_song(song)
	Global.change_soundscape(soundscape)
	Global.location = nextLocation
	dialogue_sys.set_script_path(scriptPath)
	dialogue_sys.set_next_scene_path(nextScenePath)
	Global.add_to_party(new_party_mem)
	Global.remove_from_party(mem_to_remove)
	dialogue_sys.init()
	avatar.texture = load(char_profiles[amelie])
	change_background(backgroundPath)
	change_background_sliver(sliverPath)


func _on_Control_change_char(character):
	print("Attempting to change char to ", character)
	if character != "Narrator" and character != subject and character in char_textures.keys():
		avatar.texture = load(char_profiles[char_textures[character]])


func _remove_subject():
	subject = ""
	

func _add_subject(sub: String):
	subject = sub


func change_background(res_path):
	var new_background = load(res_path)
	background.texture = new_background
	current_bg_path = res_path


func change_background_sliver(res_path):
	var new_background_sliver = load(res_path)
	bg_sliver.texture = new_background_sliver


func _on_Dialogue_tag(tags):
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
					$TransitionScreen.transition()
#					if not tag.ends_with("_repeat"):
#						bg_tags_emitted.append(tag)
				
			elif tag in char_profiles.keys():
				# might need more formal approach to distinguishing which 
				# var to load into if we have more than three characters
				if tag.begins_with("w"):
					wiggly = tag
					if current_char == "Wiggly" or current_char == "Ferryman": 
						avatar.texture = load(char_profiles[wiggly])
				elif tag.begins_with("a"):
					amelie = tag
					if current_char == "You":
						avatar.texture = load(char_profiles[amelie])
						
			elif tag == "add_wiggly":
				self._add_subject("Wiggly")
			elif tag == "add_julia":
				self._add_subject("Julia")
			elif tag == "remove_subject":
				self._remove_subject()
				
			elif tag in Global.songs:
				Global.change_song(tag)
			elif tag == "stop_song":
				Global.stop_song()
			elif tag in Global.soundscapes:
				Global.change_soundscape(tag)
			elif tag == "stop_soundscape":
				Global.stop_soundscape()
				
			get_tree().call_group("convo_sound_effect", "check_tag", tag)


func _on_TransitionScreen_transitioned():
	change_background(fade_tag_dict[fade_tag])
	change_background_sliver(fade_tag_dict_sliver[fade_tag])
	current_bg_path = fade_tag_dict[fade_tag]


func _on_Dialogue_brighten():
	print("brighten")
	avatar.brighten()


func _on_Dialogue_darken():
	print("darken")
	avatar.darken()
