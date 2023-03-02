extends Label


func _ready():
	pass


func set_text(line_text: String):
	self.text = line_text


func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
