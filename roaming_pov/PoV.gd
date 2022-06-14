extends TextureRect

export(String, FILE) var scene_up = "None"
export(String, FILE) var scene_right = "None"
export(String, FILE) var scene_down = "None"
export(String, FILE) var scene_left = "None"

signal move_pov_up
signal move_pov_down
signal move_pov_left
signal move_pov_right

func _ready():
	connect("move_pov_up", get_parent(), "_on_UpButton_pressed")
	connect("move_pov_down", get_parent(), "_on_DownButton_pressed")
	connect("move_pov_left", get_parent(), "_on_LeftButton_pressed")
	connect("move_pov_right", get_parent(), "_on_RightButton_pressed")

func _move_pov_up(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("move_pov_up")
		
func _move_pov_down(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("move_pov_down")
		
func _move_pov_left(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("move_pov_left")
		
func _move_pov_right(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("move_pov_right")
