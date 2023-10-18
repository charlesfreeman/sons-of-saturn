extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_darken":
		# play sound effect
		$SwitchFlipSlow.play()
		# tween for going fully visible to totally dark and transparent
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.75)


func _on_TweenAppear_tween_completed(object, key):
	# tween for going fully visible to totally dark and transparent
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.5)
