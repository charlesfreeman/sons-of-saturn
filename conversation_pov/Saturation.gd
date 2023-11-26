extends HSlider


func _ready():
	self.value = Global.saturation


func _on_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_saturation = value
	Global.set_saturation(value)


func reset():
	self.value = 1
