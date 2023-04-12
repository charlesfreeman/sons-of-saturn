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


# need var to store tag so we can communicate between _on_Dialogue_tag and 
# _on_TransitionScreen_transitioned methods
var fade_tag

# var to store Amelie's current emotion, since this is handled differently
var amelie_emotion = "neutral"

# array to keep track of which tags already been emitted, so we might avoid
# playing the same effects repeatedly
var bg_tags_emitted = []

# for keeping track of if we need to swap av when subject removed
var subject_speaking = false


var amelie_profiles = {
	"disgust" : "res://conversation_pov/char_profiles/amelie/amelie_disgusted.png",
	"fuming" : "res://conversation_pov/char_profiles/amelie/amelie_fuming.png",
	"guilty" : "res://conversation_pov/char_profiles/amelie/amelie_guilty.png",
	"neutral" : "res://conversation_pov/char_profiles/amelie/amelie_headshot_feathered.png",
	"questioning" : "res://conversation_pov/char_profiles/amelie/amelie_questioning.png",
	"sad" : "res://conversation_pov/char_profiles/amelie/amelie_sad.png",
	"takenaback" : "res://conversation_pov/char_profiles/amelie/amelie_taken_aback.png",
	"uncertain" : "res://conversation_pov/char_profiles/amelie/amelie_uncertain.png",
}

var wiggly_profiles = {
	"halfsmile" : "res://conversation_pov/char_profiles/wiggly/wiggly_half_smiling.png",
	"laugh" : "res://conversation_pov/char_profiles/wiggly/wiggly_laughing.png",
	"sad" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
	"skeptic" : "res://conversation_pov/char_profiles/wiggly/wiggly_skeptical.png",
	"surprise" : "res://conversation_pov/char_profiles/wiggly/wiggly_surprised.png",
	"wincing" : "res://conversation_pov/char_profiles/wiggly/wiggly_wincing.png",
	"neutral" : "res://conversation_pov/char_profiles/wiggly/wiggly_feathered_closedin.png",
}

var julia_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/julia/julia_neutral.png",
	"amused" : "res://conversation_pov/char_profiles/julia/julia_amused.png",
	"concerned" : "res://conversation_pov/char_profiles/julia/julia_concerned.png",
	"lost_in_thought" : "res://conversation_pov/char_profiles/julia/julia_lost_in_thought.png",
	"reminiscing" : "res://conversation_pov/char_profiles/julia/julia_reminiscing.png",
	"sly" : "res://conversation_pov/char_profiles/julia/julia_sly.png",
	"suspiscious" : "res://conversation_pov/char_profiles/julia/julia_suspiscious.png",
	"thinking" : "res://conversation_pov/char_profiles/julia/julia_thinking.png",
	"worried" : "res://conversation_pov/char_profiles/julia/julia_worried.png",
}

var jasper_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/jasper/jasper_headshot_feathered.png",
	"voice" : "res://conversation_pov/char_profiles/jasper/voice_headshot.png",
	"malformed_lump" : "res://conversation_pov/char_profiles/jasper/malformed_lump_headshot.png",
}

var misc_profiles = {
	"Tann" : "res://conversation_pov/char_profiles/misc/tann_profile.png",
	"Ansel" : "res://conversation_pov/char_profiles/misc/ansel_profile.png",
	"Vera" : "res://conversation_pov/char_profiles/misc/vera_profile.png",
}

# need to track state of subjects for changing profiles mid convo
var current_av = "Amelie"
var previous_av = "Amelie"

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
	change_background(backgroundPath)
	change_background_sliver(sliverPath)


# assume this is called every time either character or emotion changes
# dialogue sys does labor of tracking state
func _on_Control_change_char(character, emotion):
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
		"Wiggly":
			avatar.texture = load(wiggly_profiles[emotion])
		"Jasper":
			avatar.texture = load(jasper_profiles[emotion])
		"Julia":
			avatar.texture = load(julia_profiles[emotion])
		_:
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

			# store amelie's emotion in a local variable since it isn't to be
			# used immediately
			elif tag in amelie_profiles.keys():
				amelie_emotion = tag
				
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
