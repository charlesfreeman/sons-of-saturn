extends Area2D

export var next_scene = "None"
export var alt_next_scene = "None"
export var alt_req_prog_flag = "None"


func _ready():
	pass


func _on_ClickToSearch_mouse_entered():
	Global.set_cursor("mag_glass")


func _on_ClickToSearch_mouse_exited():
	Global.set_cursor("null")


func _on_ClickToSearch_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed:
			var options = SceneManager.create_options()
			var general_options = SceneManager.create_general_options()
			if alt_next_scene == "None" or not Global.get_prog_flag(alt_req_prog_flag):
				SceneManager.change_scene(next_scene, options, options, general_options)
			else:
				SceneManager.change_scene(alt_next_scene, options, options, general_options)
