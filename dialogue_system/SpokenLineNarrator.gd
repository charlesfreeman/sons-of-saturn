extends Label


func _ready():
	pass


func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
