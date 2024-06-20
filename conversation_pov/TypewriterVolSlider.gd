extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = Global.typewriter_vol


func _on_value_changed(new_value):
	Global.set_typewriter_vol(new_value)


func reset():
	self.value = 0
