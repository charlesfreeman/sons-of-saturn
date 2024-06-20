extends Button

var savegame = ""

signal stage_savegame(new_savegame)
signal stage_deletion(sg_to_delete)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func set_savegame(new_savegame):
	$HBoxContainer/Label.text = new_savegame
	self.savegame = "user://" + new_savegame
	if "sewer" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/big_leaking_tunnel_2.png")
	elif "morgue" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/morgue_1.png")
	elif "infirmary_1f" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/overgrowth_pink_hallway.png")
	elif "infirmary_2f" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/colorful_chair_hall.png")
	elif "iso_cells" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/isolation_cells.png")
	elif "maternity_1f" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/dome.png")
	elif "dream" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/dream_inspection_hallway.png")
	elif "tunnel" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/asbestos_tunnels.png")
	elif "office_stairwell" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/ladys_hallway_left_right_forward.png")
	elif "courtyard" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/courtyard_standing_in.png")
	elif "top_floor" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/central_blue_hallway.png")
	elif "rooftop" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/atown_rooftop_over_breezeway.png")
	elif "basement" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/basement_fork.png")
	elif "sad_place" in new_savegame:
		$HBoxContainer/TextureRect.texture = load("res://thumbnails/wiggly_sad_place.png")


func change_color(color: Color):
	$HBoxContainer/Label.add_theme_color_override("font_color", color)


func _on_focus_entered():
	change_color(Color(1,1,0,1))


func _on_focus_exited():
	change_color(Color(1,1,1,1))


func _on_mouse_entered():
	self.grab_focus()


func _on_mouse_exited():
	self.release_focus()


func _on_pressed():
	emit_signal("stage_savegame", savegame)
	
	
func disable():
	self.mouse_filter = MOUSE_FILTER_IGNORE


func enable():
	self.mouse_filter = MOUSE_FILTER_PASS 


func _on_delete_button_pressed():
	emit_signal("stage_deletion", savegame)
	
	
func check_if_deleted(deleted_sg):
	if savegame == deleted_sg:
		self.queue_free()
