extends HBoxContainer

@onready var fadein = $TweenFadeIn
@onready var hold = $TweenHold
@onready var fadeout = $TweenFadeOut


func _ready():
	pass

func save():
	fadein.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 1), 0.15, Tween.TRANS_QUAD, Tween.EASE_IN)
	fadein.start()

func _on_TweenFadeIn_tween_completed(_object, _key):
	hold.interpolate_property(self, "modulate", self.modulate, self.modulate, 0.75, Tween.TRANS_QUAD, Tween.EASE_IN)
	hold.start()


func _on_TweenHold_tween_completed(_object, _key):
	fadeout.interpolate_property(self, "modulate", self.modulate, Color(0, 0, 0, 0), 0.15, Tween.TRANS_QUAD, Tween.EASE_IN)
	fadeout.start()
