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
	"dream" : "res://roaming_pov/maps/dream_map.png",
	"tunnel" : "res://roaming_pov/maps/tunnel_map.png",
	"office_stairwell" : "res://roaming_pov/maps/office_stairwell_office_map_v2.png",
	"courtyard" : "res://roaming_pov/maps/courtyard_map.png",
	"top_floor" : "res://roaming_pov/maps/top_floor_map.png",
	"rooftop" : "res://roaming_pov/maps/rooftop_map.png",
	"basement" : "res://roaming_pov/maps/basement_map.png",
	"sad_place_tunnel_map" : "res://roaming_pov/maps/wiggly_tunnel_map.png",
	"sad_place_crib_map" : "res://roaming_pov/maps/wiggly_crib_map.png",
}

@onready var map = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/SubViewportContainer/SubViewport/TextureRect
@onready var camera = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/SubViewportContainer/SubViewport/TextureRect/Camera2D
@onready var char_rect = $HBoxContainer/VBoxContainer/MapHBox/MapBoundary/SubViewportContainer/SubViewport/TextureRect/CharRect
@onready var up_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/UpButton
@onready var right_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/RightButton
@onready var down_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/DownButton
@onready var left_button = $HBoxContainer/VBoxContainer/HBoxContainer/GridContainer/LeftButton
@onready var inventory = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Inventory
@onready var inv1 = $HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Inventory/Inv1
@onready var transition_screen = $HBoxContainer/TransitionScreen
@onready var transition_screen_texture = $HBoxContainer/TransitionScreenTexture
@onready var tile_footsteps = $HBoxContainer/TileFootsteps
@onready var wet_footsteps = $HBoxContainer/WetFootsteps
@onready var door_unlock = $HBoxContainer/DoorUnlock
@onready var esc_opts = $EscOpts
@onready var options_menu = $Options
@onready var esc_opts_resume = $EscOpts/Buttons/Resume
@onready var autosave = $Autosave
@onready var save = $Save
@onready var hbox = $HBoxContainer
@onready var amelie = $HBoxContainer/VBoxContainer/PartyContainer/Amelie
@onready var saveload = $SaveLoad
@onready var load_game_option = $SaveLoad/LoadGameOption
@onready var delete_game_option = $SaveLoad/DeleteGameOption
@onready var steam_achievement = $SteamAchievement
@onready var footstep_types = {
	"Tile" : tile_footsteps,
	"Wet" : wet_footsteps,
	"DoorUnlock" : door_unlock,
}


func _ready():
	char_rect.pivot_offset = char_rect.size / 2
	_load_PoV_instance()
	
	Global.set_scene_type("roaming_pov")
	Global.autosave()
	autosave.save()
	

func _input(event):
	if Input.is_action_pressed("ui_up"):
		if not up_button.disabled:
			_on_UpButton_pressed()
	elif Input.is_action_pressed("ui_right"):
		if not right_button.disabled:
			_on_RightButton_pressed()
	elif Input.is_action_pressed("ui_down"):
		if not down_button.disabled:
			_on_DownButton_pressed()
	elif Input.is_action_pressed("ui_left"):
		if not left_button.disabled:
			_on_LeftButton_pressed()
	elif Input.is_action_pressed("ui_cancel"):
		if load_game_option.visible:
			load_game_option.visible = false
			saveload.enable_savegames()
		elif delete_game_option.visible:
			delete_game_option.visible = false
			saveload.enable_savegames()
		elif not esc_opts.visible and not options_menu.visible and not saveload.visible:
			self._pause_game()
		elif esc_opts.visible:
			self._unpause_game()
		elif options_menu.visible:
			options_menu.visible = false
			esc_opts.visible = true
		elif saveload.visible:
			saveload.visible = false
			esc_opts.visible = true


func _on_UpButton_pressed():
	if pov_instance.non_roam_scene_up:
		SceneManager.change_scene(pov_instance.scene_up, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_up):
		_change_PoV(pov_instance.scene_up, pov_instance.footstep_type_up)
	else:
		if pov_instance.alt_scene_up != "None":
			_change_PoV(pov_instance.alt_scene_up, pov_instance.footstep_type_up)
		else:
			get_tree().call_group("nav_popups_up", "advance_popup")


func _on_RightButton_pressed():
	if pov_instance.non_roam_scene_right:
		SceneManager.change_scene(pov_instance.scene_right, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_right):
		_change_PoV(pov_instance.scene_right, pov_instance.footstep_type_right)
	else:
		if pov_instance.alt_scene_right != "None":
			_change_PoV(pov_instance.alt_scene_right, pov_instance.footstep_type_right)
		else:
			get_tree().call_group("nav_popups_right", "advance_popup")


func _on_DownButton_pressed():
	if pov_instance.non_roam_scene_down:
		SceneManager.change_scene(pov_instance.scene_down, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_down):
		_change_PoV(pov_instance.scene_down, pov_instance.footstep_type_down)
	else:
		if pov_instance.alt_scene_down != "None":
			_change_PoV(pov_instance.alt_scene_down, pov_instance.footstep_type_down)
		else:
			get_tree().call_group("nav_popups_down", "advance_popup")


func _on_LeftButton_pressed():
	if pov_instance.non_roam_scene_left:
		SceneManager.change_scene(pov_instance.scene_left, options, options, general_options)
	elif Global.get_prog_flag(pov_instance.req_flag_left):
		_change_PoV(pov_instance.scene_left, pov_instance.footstep_type_left)
	else:
		if pov_instance.alt_scene_left != "None":
			_change_PoV(pov_instance.alt_scene_left, pov_instance.footstep_type_left)
		else:
			get_tree().call_group("nav_popups_left", "advance_popup")


func _change_PoV(scene_path, foot_type):
	# load the next scene and unpack it into a node
	if scene_path != "None":
		footstep_types[foot_type].play()
		Global.set_location(scene_path)
		transition_screen.transition()


func swap_texture():
	transition_screen_texture.transition()


func _load_PoV_instance():
	pov_scene = load(Global.get_location())
	pov_instance = pov_scene.instantiate()
	
	if pov_instance.wiggly_mode:
		self._hide_amelie()
	if pov_instance.remove_jasper:
		self._hide_jasper()
	
	if pov_instance.map != "None":
		Global.set_region_enabled(pov_instance.map)
		region_local = pov_instance.map
		map.texture = load(map_paths[pov_instance.map])
	else:
		if region_local != Global.get_region():
			map.texture = load(map_paths[Global.get_region()])
			region_local = map_paths[Global.get_region()]
			
	add_child(pov_instance)
	move_child(pov_instance, 0)
	_update_buttons()
	pov_instance.connect("move_pov_up", Callable(self, "_on_UpButton_pressed"))
	pov_instance.connect("move_pov_right", Callable(self, "_on_RightButton_pressed"))
	pov_instance.connect("move_pov_down", Callable(self, "_on_DownButton_pressed"))
	pov_instance.connect("move_pov_left", Callable(self, "_on_LeftButton_pressed"))
	pov_instance.connect("disable_buttons", Callable(self, "_disable_buttons"))
	pov_instance.connect("enable_buttons", Callable(self, "_enable_buttons"))
	pov_instance.connect("swap_bg_signal", Callable(self, "swap_texture"))
	pov_instance.connect("new_item_signal", Callable(self, "_new_item"))
	pov_instance.connect("steam_achievement", Callable(self, "_steam_achievement"))
	set_pos_rot(pov_instance.position_char, pov_instance.rotation_char)


func _on_TransitionScreen_transitioned():
	remove_child(pov_instance)
	pov_instance.queue_free()
	_load_PoV_instance()


func _on_TransitionScreenTexture_transitioned():
	pov_instance.swap_bg()
	get_tree().call_group("diff_bg", "_make_visible")


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


func _pause_game():
	hbox.modulate = Color(0.6, 0.6, 0.6, 1)
	pov_instance.modulate = Color(1, 1, 1, 0.6)
	get_tree().call_group("click_areas", "disable")
	self._disable_buttons()
	Global.pause_cursor()
	esc_opts.visible = true
	esc_opts_resume.grab_focus()
	
	
func _unpause_game():
	hbox.modulate = Color(1, 1, 1, 1)
	pov_instance.modulate = Color(1, 1, 1, 1)
	get_tree().call_group("click_areas", "enable")
	self._enable_buttons()
	Global.unpause_cursor()
	esc_opts.visible = false
	
	
func _new_item(item):
	inventory.add_item(item)
	
	
func _steam_achievement(steam_ach: String):
	steam_achievement.load_ach_display(steam_ach)
	
	
func set_pos_rot(pos, rot):
	char_rect.position.x = pos.x
	char_rect.position.y = pos.y
	char_rect.rotation_degrees = rot
	camera.position.x = pos.x + (char_rect.size.x / 2)
	camera.position.y = pos.y + (char_rect.size.y / 2)


func _on_Resume_pressed():
	self._unpause_game()
	

func _on_Save_pressed():
	esc_opts.visible = false
	saveload.visible = true


func _on_Exit_pressed():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("TitleScreen", options, options, general_options)


func _on_options_pressed():
	esc_opts.visible = false
	options_menu.visible = true


func _on_exit_button_pressed():
	options_menu.visible = false
	esc_opts.visible = true


func _hide_amelie():
	amelie.visible = false
	
	
func _hide_jasper():
	inv1.clear_texture()


func _on_saveload_exit_button_pressed():
	saveload.visible = false
	esc_opts.visible = true
