extends HBoxContainer


func _ready():
	pass


func save():
	var tween_fadein = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_fadein.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15).finished
	var tween_hold = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_hold.tween_property(self, "modulate", self.modulate, 0.75).finished
	var tween_fadeout = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_fadeout.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.15).finished
