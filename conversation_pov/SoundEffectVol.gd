extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = Global.sound_effect_vol


func _on_value_changed(new_value):
	Global.set_sound_effect_vol(new_value)
	get_tree().call_group("convo_sound_effect", "reduce_volume")


func reset():
	self.value = 0
