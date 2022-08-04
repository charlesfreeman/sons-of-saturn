extends TextureRect

export(String, FILE) var scene_up = "None"
export(String, FILE) var scene_right = "None"
export(String, FILE) var scene_down = "None"
export(String, FILE) var scene_left = "None"

export(String, FILE) var popup_background = "None"

export var non_roam_scene_up = false
export var non_roam_scene_right = false
export var non_roam_scene_down = false
export var non_roam_scene_left = false

export var position = Vector2(400, 800)

export var prog_flag = "None"

onready var area = $ClickToEnter
onready var bg = self.texture

var default_bg = true

signal move_pov_up
signal move_pov_down
signal move_pov_left
signal move_pov_right

signal disable_buttons
signal enable_buttons
signal swap_bg

func _ready():
	if prog_flag != "None":
		Global.flip_prog_flag(prog_flag)
	# TODO change this to rely instead on signals
	get_parent().set_pos(position)
	for node in get_tree().get_nodes_in_group("popups"):
		print("connecting node")
		node.connect("disable_buttons", self, "_disable_buttons")
		node.connect("enable_buttons", self, "_enable_buttons")
		node.connect("swap_bg", self, "_swap_bg")

	# TODO add logic to disable clickable area if path not available

func swap_bg():
	print("swapping bg")
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
	
func _swap_bg():
	emit_signal("swap_bg")
