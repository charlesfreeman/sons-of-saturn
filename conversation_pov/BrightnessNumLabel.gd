extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str(Global.brightness)


func _on_brightness_value_changed(value):
	self.text = str(value) 
