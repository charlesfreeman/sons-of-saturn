extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = str(Global.footstep_vol)


func _on_footsteps_vol_value_changed(value):
	self.text = str(value)
