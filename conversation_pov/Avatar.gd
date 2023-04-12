extends TextureRect

onready var tween_darken = $TweenDarken
onready var tween_brighten = $TweenBrighten

var o_level = 0.75
var d_level = 0.75


func _ready():
	pass


func darken():
	tween_darken.interpolate_property(self, "modulate", 
	  self.modulate, Color(d_level, d_level, d_level, o_level), 0.1,
	  Tween.TRANS_QUART, Tween.EASE_OUT)
	tween_darken.start()
	

func brighten():
	tween_brighten.interpolate_property(self, "modulate", 
	  self.modulate, Color(1, 1, 1, 1), 0.1, 
	  Tween.TRANS_QUART, Tween.EASE_OUT)
	tween_brighten.start()

