extends HBoxContainer

func _ready():
	pass
	
	
func set_popup_image_path(popup_image_path):
	$MarginContainer/TextureRect.texture = load(popup_image_path)
	
	
func set_popup_text(popup_text):
	$Control/Label.text = popup_text

