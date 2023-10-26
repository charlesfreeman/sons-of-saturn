extends HBoxContainer


func _ready():
	pass


func set_text(line_text: String):
	$TextLine.set_text(line_text)
	$TextLine.set_font_size()
	

func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
