extends HBoxContainer

var global_scene_path = "None"
var global_texture_path = "None"
var pov_scene
var pov_instance

var options = SceneManager.create_options()
var general_options = SceneManager.create_general_options()

onready var camera = $VBoxContainer/TabContainer/Map/Viewport/MapRect/Camera2D
onready var char_rect = $VBoxContainer/TabContainer/Map/Viewport/MapRect/CharRect
onready var up_button = $VBoxContainer/HBoxContainer/GridContainer/UpButton
onready var right_button = $VBoxContainer/HBoxContainer/GridContainer/RightButton
onready var down_button = $VBoxContainer/HBoxContainer/GridContainer/DownButton
onready var left_button = $VBoxContainer/HBoxContainer/GridContainer/LeftButton
onready var tile_footsteps = $RanSoundContainer


func _ready():
	global_scene_path = Global.location
	_load_PoV_instance()
	
	Global.save_game()
	

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		_on_UpButton_pressed()
	elif Input.is_action_pressed("ui_right"):
		_on_RightButton_pressed()
	elif Input.is_action_pressed("ui_down"):
		_on_DownButton_pressed()
	elif Input.is_action_pressed("ui_left"):
		_on_LeftButton_pressed()



func _on_UpButton_pressed():
	if pov_instance.non_roam_scene_up:
		SceneManager.change_scene(pov_instance.scene_up, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_up):
		change_PoV(pov_instance.scene_up)
	else:
		if pov_instance.alt_scene_up != "None":
			change_PoV(pov_instance.alt_scene_up)
		else:
			get_tree().call_group("nav_popups_up", "init_popup")


func _on_RightButton_pressed():
	if pov_instance.non_roam_scene_right:
		SceneManager.change_scene(pov_instance.scene_right, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_right):
		change_PoV(pov_instance.scene_right)
	else:
		if pov_instance.alt_scene_right != "None":
			change_PoV(pov_instance.alt_scene_right)
		else:
			get_tree().call_group("nav_popups_right", "init_popup")


func _on_DownButton_pressed():
	if pov_instance.non_roam_scene_down:
		SceneManager.change_scene(pov_instance.scene_down, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_down):
		change_PoV(pov_instance.scene_down)
	else:
		if pov_instance.alt_scene_down != "None":
			change_PoV(pov_instance.alt_scene_down)
		else:
			get_tree().call_group("nav_popups_down", "init_popup")


func _on_LeftButton_pressed():
	if pov_instance.non_roam_scene_left:
		SceneManager.change_scene(pov_instance.scene_left, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_left):
		change_PoV(pov_instance.scene_left)
	else:
		if pov_instance.alt_scene_left != "None":
			change_PoV(pov_instance.alt_scene_left)
		else:
			get_tree().call_group("nav_popups_left", "init_popup")


func change_PoV(scene_path):
	tile_footsteps.play()
	# load the next scene and unpack it into a node
	if scene_path != "None":
		global_scene_path = scene_path
		$TransitionScreen.transition()


func swap_texture():
	$TransitionScreenTexture.transition()


func _load_PoV_instance():
	pov_scene = load(global_scene_path)
	pov_instance = pov_scene.instance()
	add_child(pov_instance)
	move_child(pov_instance, 0)
	_update_buttons()
	pov_instance.connect("move_pov_up", self, "_on_UpButton_pressed")
	pov_instance.connect("move_pov_right", self, "_on_RightButton_pressed")
	pov_instance.connect("move_pov_down", self, "_on_DownButton_pressed")
	pov_instance.connect("move_pov_left", self, "_on_LeftButton_pressed")
	pov_instance.connect("disable_buttons", self, "_disable_buttons")
	pov_instance.connect("enable_buttons", self, "_enable_buttons")
	pov_instance.connect("swap_bg", self, "swap_texture")


func _on_TransitionScreen_transitioned():
	remove_child(pov_instance)
	_load_PoV_instance()


func _on_TransitionScreenTexture_transitioned():
	pov_instance.swap_bg()
	get_tree().call_group("diff_bg", "make_visible")


func _update_buttons():
	if pov_instance.scene_up == "None":
		up_button.disabled = true
	else:
		up_button.disabled = false
	if pov_instance.scene_right == "None":
		right_button.disabled = true
	else:
		right_button.disabled = false
	if pov_instance.scene_down == "None":
		down_button.disabled = true
	else:
		down_button.disabled = false
	if pov_instance.scene_left == "None":
		left_button.disabled = true
	else:
		left_button.disabled = false
	
	
func _disable_buttons():
	up_button.disabled = true
	right_button.disabled = true
	down_button.disabled = true
	left_button.disabled = true
	

func _enable_buttons():
	_update_buttons()
	
	
func set_pos(pos):
	char_rect.rect_position.x = pos.x
	char_rect.rect_position.y = pos.y
	camera.position.x = pos.x
	camera.position.y = pos.y

