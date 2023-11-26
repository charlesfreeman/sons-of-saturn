extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready():
	self.value = Global.sound_track_vol


func _on_value_changed(value):
	Global.set_sound_track_vol(value)
	get_tree().call_group("track", "reduce_volume")


func reset():
	self.value = 0 
