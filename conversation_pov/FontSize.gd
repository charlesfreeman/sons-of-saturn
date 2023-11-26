extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = Global.font_size
	self.grab_focus()


func _on_value_changed(value):
	Global.set_font_size(value)
	get_tree().call_group("SpokenLines", "set_font_size")
	get_tree().call_group("lines_container", "set_separation")


func reset():
	self.value = 48
