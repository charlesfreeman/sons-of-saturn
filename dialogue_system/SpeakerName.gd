extends RichTextLabel


func _ready():
	if Global.retro_font_mode:
		set_retro_font()


func set_retro_font():
	var new_font = load("res://fonts/retro_computer_personal_use.ttf")
	self.add_theme_font_override("font", new_font)
	self.add_theme_color_override("font_color", Color(0,1,0,1))
	
	
func set_font_size():
	self.add_theme_font_size_override("normal_font_size", Global.font_size)
	
	
func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
