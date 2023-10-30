extends Area2D

var in_area = false

@export var next_scene = "None"
@export var alt_next_scene = "None"
@export var alt_req_prog_flag = "None"


func _ready():
	pass


func _on_ClickToSearch_mouse_entered():
	in_area = true
	Global.set_cursor("mag_glass")


func _on_ClickToSearch_mouse_exited():
	in_area = false
	Global.search_release_cursor()
	
	
func _change_scene():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	if alt_next_scene == "None" or not Global.get_prog_flag(alt_req_prog_flag):
		SceneManager.change_scene(next_scene, options, options, general_options)
	else:
		SceneManager.change_scene(alt_next_scene, options, options, general_options)


func _on_ClickToSearch_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed):
		self._change_scene()


func _input(event):
	if Input.is_action_pressed("ui_accept") and in_area:
		self._change_scene()
