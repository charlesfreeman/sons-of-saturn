extends HSlider


func _ready():
	self.value = Global.saturation


func _on_value_changed(new_value):
	GlobalWorldEnvironment.environment.adjustment_saturation = new_value
	Global.set_saturation(new_value)


func reset():
	self.value = 1
