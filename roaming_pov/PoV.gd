extends TextureRect

@export var scene_up = "None" # (String, FILE)
@export var scene_right = "None" # (String, FILE)
@export var scene_down = "None" # (String, FILE)
@export var scene_left = "None" # (String, FILE)

@export var alt_scene_up = "None" # (String, FILE)
@export var alt_scene_right = "None" # (String, FILE)
@export var alt_scene_down = "None" # (String, FILE)
@export var alt_scene_left = "None" # (String, FILE)

@export var popup_background = "None" # (String, FILE)

@export var non_roam_scene_up = false
@export var non_roam_scene_right = false
@export var non_roam_scene_down = false
@export var non_roam_scene_left = false

@export var req_flag_up = "None"
@export var req_flag_right = "None"
@export var req_flag_down = "None"
@export var req_flag_left = "None"

@export var prog_flag = "None"

@export var position_char = Vector2(800, 800)
@export var rotation_char = 0

@export var song = "None"
@export var soundscape = "None"

# change this to "Wet" to change to wet footsteps
# will likely add more options later
@export var footstep_type_up = "Tile"
@export var footstep_type_right = "Tile"
@export var footstep_type_down = "Tile"
@export var footstep_type_left = "Tile"

# set this to something if new mini-map needed when entering this area
@export var map = "None"

# functionality to moving to new scene instead of new PoV already exists but sometimes more natural
# to transition after having entered new PoV
@export var new_scene_on_ready = false
@export var new_scene = "None" # (String, FILE)

@onready var area = $ClickToEnter
@onready var bg = self.texture

var default_bg = true

signal move_pov_up
signal move_pov_down
signal move_pov_left
signal move_pov_right

signal disable_buttons
signal enable_buttons
signal swap_bg_signal
signal new_item_signal(item)

func _ready():
	Global.set_cursor("null")
	# currently all convos that start with entering a room are one-offs. here we load the convo 
	# only if the prog flag for this PoV has not yet been flipped.  If it has it isn't loaded. 
	if new_scene_on_ready and not Global.get_prog_flag(prog_flag):
		Global.flip_prog_flag(prog_flag)
		await get_tree().create_timer(1.0).timeout
		var options = SceneManager.create_options()
		var general_options = SceneManager.create_general_options()
		SceneManager.change_scene(new_scene, options, options, general_options)
	elif prog_flag != "None":
		Global.flip_prog_flag(prog_flag)
		
	# TODO change this to rely instead on signals
	# get_parent().set_pos(position)
	
	Global.change_song(song)
	Global.change_soundscape(soundscape)
	
	for node in get_tree().get_nodes_in_group("popups"):
		node.connect("disable_buttons", Callable(self, "_disable_buttons"))
		node.connect("enable_buttons", Callable(self, "_enable_buttons"))
		node.connect("swap_bg_signal", Callable(self, "_swap_bg_signal"))
	for node in get_tree().get_nodes_in_group("desc_popups"):
		node.connect("new_item_signal", Callable(self, "_new_item"))


func swap_bg():
	if self.default_bg:
		self.texture = load(popup_background)
		self.default_bg = false
	else:
		self.texture = bg
		self.default_bg = true

func _move_pov_up():
	emit_signal("move_pov_up")
	
func _move_pov_right():
	emit_signal("move_pov_right")

func _move_pov_down():
	emit_signal("move_pov_down")

func _move_pov_left():
	emit_signal("move_pov_left")
	
func _disable_buttons():
	emit_signal("disable_buttons")
	
func _enable_buttons():
	emit_signal("enable_buttons")
	
func _swap_bg_signal():
	emit_signal("swap_bg_signal")
	
func _new_item(item):
	emit_signal("new_item_signal", item)
