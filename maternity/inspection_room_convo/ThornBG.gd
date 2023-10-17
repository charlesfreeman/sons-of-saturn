extends TextureRect

@onready var tween_appear = create_tween()
@onready var tween_disappear = create_tween()


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_darken":
		# play sound effect
		$SwitchFlipSlow.play()
		# tween for going fully visible to totally dark and transparent
		tween_appear.tween_property(self, "modulate", Color(1, 1, 1, 1), 
		  0.75).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func _on_TweenAppear_tween_completed(object, key):
	# tween for going fully visible to totally dark and transparent
	tween_disappear.tween_property(self, "modulate", Color(0, 0, 0, 0), 
	  0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
