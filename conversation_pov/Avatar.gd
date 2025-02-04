extends TextureRect

var o_level = 0.75
var d_level = 0.75


func _ready():
	pass


func darken():
	var tween_darken = create_tween() 
	tween_darken.tween_property(self, "modulate", Color(d_level, d_level, d_level, o_level), 
	  0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	

func brighten():
	var tween_brighten =  create_tween()
	tween_brighten.tween_property(self, "modulate", Color(1, 1, 1, 1), 
	  0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)

