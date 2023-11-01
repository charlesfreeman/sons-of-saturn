extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_appear":
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	elif tag == "red_bg_darken":
		var tween_red = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await tween_red.tween_property(self, "modulate", Color(1, 0, 0, 1), 0.25).finished
		var tween_lighten = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await tween_lighten.tween_property(self, "modulate", Color(1, 0.5, 0.5, 1), 5).finished
		var tween_transparent = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween_transparent.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2)
