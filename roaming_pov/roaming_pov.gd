extends Control

var pov_scene
var pov_instance

# needed for checking against global region variable to determine if reloading
# the map is necessary when "None" encountered
var region_local = "None"

var options = SceneManager.create_options()
var general_options = SceneManager.create_general_options()

var map_paths = {
	"sewer" : "res://roaming_pov/maps/sewer_map.png",
	"morgue" : "res://roaming_pov/maps/morgue_map.png",
	"infirmary_1f" : "res://roaming_pov/maps/infirmary_1f_map.png",
	"infirmary_2f" : "res://roaming_pov/maps/infirmary_2f_map.png",
	"iso_cells" : "res://roaming_pov/maps/iso_cells_map.png",
	"maternity_1f" : "res://roaming_pov/maps/maternity_1f_map.png",
	"dream" : "res://roaming_pov/maps/dream_map.png"
}

onready var map = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/ViewportContainer/Viewport/TextureRect
onready var camera = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/ViewportContainer/Viewport/TextureRect/Camera2D
onready var char_rect = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/ViewportContainer/Viewport/TextureRect/CharRect
onready var up_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/UpButton
onready var right_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/RightButton
onready var down_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/DownButton
onready var left_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/LeftButton
onready var inventory = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Inventory
onready var transition_screen = $HBoxContainer/TransitionScreen
onready var transition_screen_texture = $HBoxContainer/TransitionScreenTexture
onready var tile_footsteps = $HBoxContainer/TileFootsteps
onready var wet_footsteps = $HBoxContainer/WetFootsteps
onready var esc_opts = $EscOpts
onready var autosave = $Autosave
onready var save = $Save
onready var hbox = $HBoxContainer
onready var footstep_types = {
	"Tile" : tile_footsteps,
	"Wet" : wet_footsteps,
}


func _ready():
	char_rect.rect_pivot_offset = char_rect.rect_size / 2
	_load_PoV_instance()
	
	Global.save_game()
	autosave.save()
	

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		_on_UpButton_pressed()
	elif Input.is_action_pressed("ui_right"):
		_on_RightButton_pressed()
	elif Input.is_action_pressed("ui_down"):
		_on_DownButton_pressed()
	elif Input.is_action_pressed("ui_left"):
		_on_LeftButton_pressed()
	elif Input.is_action_pressed("ui_cancel"):
		if not esc_opts.visible:
			hbox.modulate = Color(1, 1, 1, 0.6)
			get_tree().call_group("click_areas", "disable")
			self._disable_buttons()
			esc_opts.visible = true
		else:
			hbox.modulate = Color(1, 1, 1, 1)
			get_tree().call_group("click_areas", "enable")
			self._enable_buttons()
			esc_opts.visible = false


func _on_UpButton_pressed():
	if pov_instance.non_roam_scene_up:
		SceneManager.change_scene(pov_instance.scene_up, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_up):
		_change_PoV(pov_instance.scene_up)
	else:
		if pov_instance.alt_scene_up != "None":
			_change_PoV(pov_instance.alt_scene_up)
		else:
			get_tree().call_group("nav_popups_up", "init_popup")


func _on_RightButton_pressed():
	if pov_instance.non_roam_scene_right:
		SceneManager.change_scene(pov_instance.scene_right, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_right):
		_change_PoV(pov_instance.scene_right)
	else:
		if pov_instance.alt_scene_right != "None":
			_change_PoV(pov_instance.alt_scene_right)
		else:
			get_tree().call_group("nav_popups_right", "init_popup")


func _on_DownButton_pressed():
	if pov_instance.non_roam_scene_down:
		SceneManager.change_scene(pov_instance.scene_down, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_down):
		_change_PoV(pov_instance.scene_down)
	else:
		if pov_instance.alt_scene_down != "None":
			_change_PoV(pov_instance.alt_scene_down)
		else:
			get_tree().call_group("nav_popups_down", "init_popup")


func _on_LeftButton_pressed():
	if pov_instance.non_roam_scene_left:
		SceneManager.change_scene(pov_instance.scene_left, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_left):
		_change_PoV(pov_instance.scene_left)
	else:
		if pov_instance.alt_scene_left != "None":
			_change_PoV(pov_instance.alt_scene_left)
		else:
			get_tree().call_group("nav_popups_left", "init_popup")


func _change_PoV(scene_path):
	footstep_types[pov_instance.footstep_type].play()
	# load the next scene and unpack it into a node
	if scene_path != "None":
		Global.set_location(scene_path)
		transition_screen.transition()


func swap_texture():
	transition_screen_texture.transition()


func _load_PoV_instance():
	pov_scene = load(Global.get_location())
	pov_instance = pov_scene.instance()
	if pov_instance.map != "None":
		Global.set_region(pov_instance.map)
		region_local = pov_instance.map
		map.texture = load(map_paths[pov_instance.map])
	else:
		if region_local != Global.get_region():
			map.texture = load(map_paths[Global.get_region()])
			region_local = map_paths[Global.get_region()]
			
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
	pov_instance.connect("new_item", self, "_new_item")
	set_pos_rot(pov_instance.position, pov_instance.rotation)


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
	
	
func _new_item(item):
	inventory.add_item(item)
	
	
func set_pos_rot(pos, rot):
	char_rect.rect_position.x = pos.x
	char_rect.rect_position.y = pos.y
	char_rect.rect_rotation = rot
	camera.position.x = pos.x + (char_rect.rect_size.x / 2)
	camera.position.y = pos.y + (char_rect.rect_size.y / 2)

func _on_Resume_pressed():
	self.modulate = Color(1, 1, 1, 1)
	get_tree().call_group("click_areas", "enable")
	self._enable_buttons()
	esc_opts.visible = false

func _on_Save_pressed():
	save.save()
	Global.save_game()

func _on_Exit_pressed():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("TitleScreen", options, options, general_options)

