extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_appear":
		# tween for going fully visible to totally dark and transparent
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	elif tag == "red_bg_darken":
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 0, 0, 1), 0.25)


func _on_TweenDarken_tween_completed(object, key):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1, 0.5, 0.5, 1), 5)


func _on_TweenPartial_tween_completed(object, key):
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)

