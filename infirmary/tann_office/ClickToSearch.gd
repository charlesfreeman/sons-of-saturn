extends Area2D

export var next_scene = ""

onready var mag_glass = load("res://roaming_pov/images/mag_glass.png")


func _ready():
	pass


func _on_ClickToSearch_mouse_entered():
	Input.set_custom_mouse_cursor(mag_glass)


func _on_ClickToSearch_mouse_exited():
	Input.set_custom_mouse_cursor(null)


func _on_ClickToSearch_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
		and event.button_index == BUTTON_LEFT \
		and event.pressed:
			var options = SceneManager.create_options()
			var general_options = SceneManager.create_general_options()
			SceneManager.change_scene(next_scene, options, options, general_options)
