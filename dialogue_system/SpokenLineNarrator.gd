extends Label


func _ready():
	set_font_size()


func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)


func set_font_size():
	self.add_theme_font_size_override("font_size", Global.font_size)
