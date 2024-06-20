extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_camera_2d_swap_texture():
	self.texture = load("res://childrens_ward/julia_hand_on_lever/solid_dark_red.png")
	Global.change_song("None")
	$Lever.play()
