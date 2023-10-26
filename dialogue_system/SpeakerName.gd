extends RichTextLabel


func _ready():
	pass


func set_font_size():
	self.add_theme_font_size_override("normal_font_size", Global.font_size)
