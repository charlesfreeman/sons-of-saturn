extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_darken":
		# play sound effect
		$SwitchFlipSlow.play()
		var tween_appear = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await tween_appear.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.75).finished
		var tween_disappear = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween_disappear.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.5)
