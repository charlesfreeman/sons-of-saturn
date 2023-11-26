extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = Global.footstep_vol


func _on_value_changed(value):
	Global.set_footstep_vol(value)


func reset():
	self.value = 0
