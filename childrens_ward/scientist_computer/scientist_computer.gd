extends Node2D

@onready var dialogue_sys = $DialogueSys


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_cursor("null")
	Global.retro_font_mode = true
	dialogue_sys.set_script_path("res://childrens_ward/scientist_computer/scientist_computer.json")
	if not Global.get_prog_flag("scientist_computer_convo_2"):
		dialogue_sys.set_next_scene_path("scientist_desk_convo_2")
	else:
		dialogue_sys.set_next_scene_path("roaming_pov")
		dialogue_sys.set_next_location("res://childrens_ward/scientist_desk/scientist_desk.tscn")
	dialogue_sys.init()


func _on_dialogue_sys_tag(tags):
	for tag in tags:
		if tag == "retro_mode_false":
			Global.retro_font_mode = false
