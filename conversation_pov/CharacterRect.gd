extends TextureRect

@export var on_start = false
@export var dark_on_start = false
@export var appear_tag = ""
@export var disappear_tag = ""
@export var disappear_slow_tag = ""
@export var brighten_tag = ""
@export var darken_tag = ""
@export var appear_dark_tag = ""


func _ready():
	if on_start:
		var tween_in = create_tween()
		tween_in.tween_property(self, "modulate", Color(1, 1, 1, 1), 
		  0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	elif dark_on_start:
		var tween_darken = create_tween()
		tween_darken.tween_property(self, "modulate", Color(0.35, 0.35, 0.35, 1), 
		  0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)


func appear_disappear(tag):
	match tag:
		appear_tag:
			var tween_in = create_tween()
			tween_in.tween_property(self, "modulate", Color(1, 1, 1, 1), 
			  0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		disappear_tag:
			var tween_out = create_tween()
			tween_out.tween_property(self, "modulate", Color(1, 1, 1, 0), 
			  0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		disappear_slow_tag:
			var tween_out_slow = create_tween()
			tween_out_slow.tween_property(self, "modulate", Color(1, 1, 1, 0), 
			  1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		brighten_tag:
			var tween_brighten = create_tween()
			tween_brighten.tween_property(self, "modulate", Color(1, 1, 1, 1), 
			  0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		darken_tag:
			var tween_darken = create_tween()
			tween_darken.tween_property(self, "modulate", Color(0.1, 0.1, 0.1, 1), 
			  0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		appear_dark_tag:
			var tween_appear_dark = create_tween()
			tween_appear_dark.tween_property(self, "modulate", Color(0.35, 0.35, 0.35, 1), 
			  0.8).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
