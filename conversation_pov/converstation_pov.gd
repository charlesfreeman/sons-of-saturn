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

onready var avatar = $View/CanvasLayer/Avatar
onready var background = $View
onready var bg_sliver = $RightSideBG
onready var dialogue_sys = $HBoxContainer/Dialogue
var amelie = "aneutral"
var wiggly = "wneutral"
var current_char = "You"

# need var to store tag so we can communicate between _on_Dialogue_tag and 
# _on_TransitionScreen_transitioned methods
var fade_tag

# array to keep track of which tags already been emitted, so we might avoid
# playing the same effects repeatedly
var tags_emitted = []

var char_textures = {
	# not sure these two are needed anymore
	"None": amelie,
	"You": amelie, 
	"Wiggly": wiggly, 
	"Ferryman": wiggly,
}

var char_profiles = {
	"adisgust" : "res://conversation_pov/char_profiles/amelie/amelie_disgusted.png",
	"afuming" : "res://conversation_pov/char_profiles/amelie/amelie_fuming.png",
	"aguilty" : "res://conversation_pov/char_profiles/amelie/amelie_guilty.png",
	"aneutral" : "res://conversation_pov/char_profiles/amelie/amelie_neutral.png",
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
	"wneutral" : "res://conversation_pov/char_profiles/wiggly/wigley_headshot_feathered.png",
}

signal tag(tag)


func _ready():
	if prog_flag != "None":
		Global.flip_prog_flag(prog_flag)
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
	if character != "Voice" and character != subject and character in char_textures.keys():
		avatar.texture = load(char_profiles[char_textures[character]])


func _remove_subject():
	subject = ""
	

func _add_subject(sub: String):
	subject = sub


func change_background(res_path):
	var new_background = load(res_path)
	background.texture = new_background


func change_background_sliver(res_path):
	var new_background_sliver = load(res_path)
	bg_sliver.texture = new_background_sliver


func _on_Dialogue_tag(tags):
	for tag in tags:
		print("tag: ", tag)
		
		# sometimes need to add or drop subject mid-convo
		# TODO add mechanism for adding or dropping subject
		
		emit_signal("tag", tag)
		get_tree().call_group("CharacterRects", "appear_disappear", tag)
		if not tag in tags_emitted:
			if tag in tag_dict.keys():
				change_background(tag_dict[tag])
				change_background_sliver(tag_dict_sliver[tag])
			elif tag in fade_tag_dict.keys():
				fade_tag = tag
				$TransitionScreen.transition()
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
			tags_emitted.append(tag)


func _on_TransitionScreen_transitioned():
	print("changing to fade background")
	change_background(fade_tag_dict[fade_tag])
	change_background_sliver(fade_tag_dict_sliver[fade_tag])
