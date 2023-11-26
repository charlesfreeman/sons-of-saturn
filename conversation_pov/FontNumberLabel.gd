extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str(Global.font_size)


func _on_font_size_value_changed(value):
	self.text = str(value)
