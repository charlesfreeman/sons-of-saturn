extends HBoxContainer

export var subject = ""
export(String, FILE, "*.json") var scriptPath = "res://dialogue_system/conversations/test_scene.json"
export(String, FILE, "*.png") var backgroundPath = "res://images/looking_up_well_square.png"
export(String, FILE) var soundscapePath = "res://sounds/545664__nox-sound__ambiance-stream-sewer-reverb-small-loop-stereo-dr05.wav"
export(String, FILE, "*.tscn") var nextScenePath = "res://roaming_pov/roaming_pov.tscn"
export(String, FILE, "*.tscn") var nextLocation = "res://infirmary/post_office/PostOfficeMural.tscn"
export var tag_dict = {}
# might need to refactor to array if ever want to add more than one party mem
# following a convo
export var new_party_mem = ""
export var mem_to_remove = ""

onready var avatar = $View/Control/Avatar
onready var background = $View
onready var dialogue_sys = $HBoxContainer/Dialogue
var amelie_alone = "res://conversation_pov/amelie-bust-no-mirror.png"
var amelie_in_mirror = "res://conversation_pov/clean-mirror-amelie-isolated.png"
var wigley = "res://conversation_pov/wigley_looking_left_cropped_filtered.png"

var char_textures = {
	"amelie": amelie_alone, 
	"None": amelie_in_mirror,
	"You": amelie_in_mirror, 
	"Wigley": wigley, 
	"Ferryman": wigley,
}


func _ready():
	Global.location = nextLocation
	dialogue_sys.set_script_path(scriptPath)
	dialogue_sys.set_next_scene_path(nextScenePath)
	dialogue_sys.set_mem_to_add(new_party_mem)
	dialogue_sys.set_mem_to_remove(mem_to_remove)
	dialogue_sys.init()
	avatar.texture = load(amelie_in_mirror)


func _on_Control_change_char(character):
	if character != "Voice" and character != subject:
		avatar.texture = load(char_textures[character])


func change_background(res_path):
	var new_background = load(res_path)
	background.texture = new_background


func _on_Dialogue_tag(tags):
	print("tags: ", tags)
	for tag in tags:
		print("tag: ", tag)
		if tag in tag_dict.keys():
			print("changing background: ", tag_dict[tag])
			change_background(tag_dict[tag])
