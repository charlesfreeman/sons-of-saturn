extends HBoxContainer

var global_scene_path = "None"


func _ready():
	_update_buttons()
	

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		change_PoV($PoV.scene_up)
	elif Input.is_action_pressed("ui_right"):
		change_PoV($PoV.scene_right)
	elif Input.is_action_pressed("ui_down"):
		change_PoV($PoV.scene_down)
	elif Input.is_action_pressed("ui_left"):
		change_PoV($PoV.scene_left)


# func _on_Area2D2_input_event(_viewport, event, _shape_idx):
# 	if event is InputEventMouseButton \
#	and event.button_index == BUTTON_LEFT \
#	and event.pressed:
#		SceneManager.change_scene(scene_right, {"speed": 3.8, "wait_time": 0.3})


func _on_RightButton_pressed():
	change_PoV($PoV.scene_right)


func _on_DownButton_pressed():
	change_PoV($PoV.scene_down)


func _on_LeftButton_pressed():
	change_PoV($PoV.scene_left)


func _on_UpButton_pressed():
	change_PoV($PoV.scene_up)
	
	
func change_PoV(scene_path):
	# load the next scene and unpack it into a node
	if scene_path != "None":
		global_scene_path = scene_path
		$TransitionScreen.transition()


func _on_TransitionScreen_transitioned():
	var scene = load(global_scene_path)
	var node = scene.instance()
	remove_child($PoV)
	add_child(node)
	move_child(node, 0)
	_update_buttons()
	

func _update_buttons():
	if $PoV.scene_up == "None":
		$VBoxContainer/GridContainer/UpButton.disabled = true
	else:
		$VBoxContainer/GridContainer/UpButton.disabled = false
	if $PoV.scene_right == "None":
		$VBoxContainer/GridContainer/RightButton.disabled = true
	else:
		$VBoxContainer/GridContainer/RightButton.disabled = false
	if $PoV.scene_down == "None":
		$VBoxContainer/GridContainer/DownButton.disabled = true
	else:
		$VBoxContainer/GridContainer/DownButton.disabled = false
	if $PoV.scene_left == "None":
		$VBoxContainer/GridContainer/LeftButton.disabled = true
	else:
		$VBoxContainer/GridContainer/LeftButton.disabled = false
	
