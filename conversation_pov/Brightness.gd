extends HSlider


func _ready():
	self.value = Global.brightness


func _on_value_changed(new_value):
	Global.set_brightness(new_value)
	GlobalWorldEnvironment.environment.adjustment_brightness = new_value


func reset():
	self.value = 1
