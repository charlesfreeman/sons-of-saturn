extends HSlider


func _ready():
	self.value = Global.contrast


func _on_value_changed(new_value):
	GlobalWorldEnvironment.environment.adjustment_contrast = new_value
	Global.set_contrast(new_value)


func reset():
	self.value = 1 
