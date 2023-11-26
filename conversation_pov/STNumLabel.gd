extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str(Global.sound_track_vol)


func _on_sound_track_vol_value_changed(value):
	self.text = str(value)
