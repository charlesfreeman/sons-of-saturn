extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	set_separation()


# this actually works out pretty well, no math required
func set_separation():
	self.add_theme_constant_override("separation", min(Global.font_size, 48))
