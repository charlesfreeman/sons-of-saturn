extends Area2D


export(NodePath) var my_collision_polygon_node_path

export var up_path = false
export var right_path = false
export var down_path = false
export var left_path = false

var pointer_up = load("res://images/up_pointer_blue.png")
var pointer_right = load("res://images/right_pointer_blue.png")
var pointer_down = load("res://images/down_pointer_blue.png")
var pointer_left = load("res://images/left_pointer_blue.png")

var enabled = true

signal up
signal right
signal down
signal left


func _ready():
	add_to_group("click_areas")
	# should probably be doing this in the parent node but fuck it
	connect("up", get_parent(), "_move_pov_up")
	connect("right", get_parent(), "_move_pov_right")
	connect("down", get_parent(), "_move_pov_down")
	connect("left", get_parent(), "_move_pov_left")


func _on_ClickToEnter_mouse_entered():
	if self.enabled:
		if up_path:
			Input.set_custom_mouse_cursor(pointer_up)
		elif right_path:
			Input.set_custom_mouse_cursor(pointer_right)
		elif down_path:
			Input.set_custom_mouse_cursor(pointer_down)
		elif left_path:
			Input.set_custom_mouse_cursor(pointer_left)
		

func _on_ClickToEnter_mouse_exited():
	if self.enabled:
		Input.set_custom_mouse_cursor(null)


func _on_ClickToEnter_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if self.enabled:
			if up_path:
				emit_signal("up")
			elif right_path:
				emit_signal("right")
			elif down_path:
				emit_signal("down")
			elif left_path:
				emit_signal("left")


func enable():
	self.enabled = true
		
		
func disable():
	self.enabled = false
