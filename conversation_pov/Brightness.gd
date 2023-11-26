extends HSlider


func _ready():
	self.value = Global.brightness


func _on_value_changed(value):
	Global.set_brightness(value)
	GlobalWorldEnvironment.environment.adjustment_brightness = value


func reset():
	self.value = 1
