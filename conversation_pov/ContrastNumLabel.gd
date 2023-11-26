extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str(Global.contrast)


func _on_contrast_value_changed(value):
	self.text = str(value)
