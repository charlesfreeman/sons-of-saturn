extends HSlider


func _ready():
	self.value = Global.contrast


func _on_value_changed(value):
	GlobalWorldEnvironment.environment.adjustment_contrast = value
	Global.set_contrast(value)


func reset():
	self.value = 1 
