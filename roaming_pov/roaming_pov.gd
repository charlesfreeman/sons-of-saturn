extends HBoxContainer

var global_scene_path = "None"
var pov_scene
var pov_instance


func _ready():
	print("global location: ", Global.location)
	pov_instance = load(Global.location).instance()
	add_child(pov_instance)
	move_child(pov_instance, 0)
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


func _on_RightButton_pressed():
	change_PoV(pov_instance.scene_right)


func _on_DownButton_pressed():
	change_PoV(pov_instance.scene_down)


func _on_LeftButton_pressed():
	change_PoV(pov_instance.scene_left)


func _on_UpButton_pressed():
	change_PoV(pov_instance.scene_up)
	
	
func change_PoV(scene_path):
	# load the next scene and unpack it into a node
	if scene_path != "None":
		global_scene_path = scene_path
		$TransitionScreen.transition()


func _on_TransitionScreen_transitioned():
	remove_child(pov_instance)
	pov_scene = load(global_scene_path)
	pov_instance = pov_scene.instance()
	add_child(pov_instance)
	move_child(pov_instance, 0)
	_update_buttons()
	

func _update_buttons():
	if $PoV.scene_up == "None":
		$VBoxContainer/HBoxContainer/GridContainer/UpButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/GridContainer/UpButton.disabled = false
	if $PoV.scene_right == "None":
		$VBoxContainer/HBoxContainer/GridContainer/RightButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/GridContainer/RightButton.disabled = false
	if $PoV.scene_down == "None":
		$VBoxContainer/HBoxContainer/GridContainer/DownButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/GridContainer/DownButton.disabled = false
	if $PoV.scene_left == "None":
		$VBoxContainer/HBoxContainer/GridContainer/LeftButton.disabled = true
	else:
		$VBoxContainer/HBoxContainer/GridContainer/LeftButton.disabled = false
	
