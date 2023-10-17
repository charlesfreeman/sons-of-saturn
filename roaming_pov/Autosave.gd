extends HBoxContainer

@onready var tween_fadein = create_tween()
@onready var tween_hold = create_tween()
@onready var tween_fadeout = create_tween()


func _ready():
	pass

func save():
	tween_fadein.tween_property(self, "modulate", Color(1, 1, 1, 1), 
	  0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _on_TweenFadeIn_tween_completed(_object, _key):
	tween_hold.tween_property(self, "modulate", self.modulate, 0.75)


func _on_TweenHold_tween_completed(_object, _key):
	tween_fadeout.tween_property(self, "modulate", Color(0, 0, 0, 0), 
	  0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
