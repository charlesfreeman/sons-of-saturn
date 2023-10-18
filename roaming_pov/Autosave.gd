extends HBoxContainer


func _ready():
	pass


func save():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)


func _on_TweenFadeIn_tween_completed(_object, _key):
	var tween = create_tween()
	tween.tween_property(self, "modulate", self.modulate, 0.75)


func _on_TweenHold_tween_completed(_object, _key):
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.15)
