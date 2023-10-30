extends Area2D

var in_area = false

@export var up_path = false
@export var right_path = false
@export var down_path = false
@export var left_path = false

signal up
signal right
signal down
signal left


func _ready():
	add_to_group("click_areas")
	# should probably be doing this in the parent node but fuck it
	connect("up", Callable(get_parent(), "_move_pov_up"))
	connect("right", Callable(get_parent(), "_move_pov_right"))
	connect("down", Callable(get_parent(), "_move_pov_down"))
	connect("left", Callable(get_parent(), "_move_pov_left"))


func _on_ClickToEnter_mouse_entered():
	in_area = true
	if up_path:
		Global.set_cursor("pointer_up")
	elif right_path:
		Global.set_cursor("pointer_right")
	elif down_path:
		Global.set_cursor("pointer_down")
	elif left_path:
		Global.set_cursor("pointer_left")
		

func _on_ClickToEnter_mouse_exited():
	in_area = false
	Global.enter_release_cursor()


func _signal_path():
	if up_path:
		emit_signal("up")
	elif right_path:
		emit_signal("right")
	elif down_path:
		emit_signal("down")
	elif left_path:
		emit_signal("left")


func _on_ClickToEnter_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed):
		self._signal_path()


func _input(event):
	# using input_pickable as proxy for enabled / disabled
	if Input.is_action_pressed("ui_accept") and in_area and self.input_pickable:
		self._signal_path()
		

func enable():
	self.input_pickable = true
		
		
func disable():
	self.input_pickable = false
