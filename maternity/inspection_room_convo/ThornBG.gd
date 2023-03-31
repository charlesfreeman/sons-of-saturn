extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_darken":
		# play sound effect
		$SwitchFlipSlow.play()
		# tween for going fully visible to totally dark and transparent
		$TweenAppear.interpolate_property(self, "modulate", 
		self.modulate, Color(1, 1, 1, 1), 0.75, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		$TweenAppear.start()


func _on_TweenAppear_tween_completed(object, key):
	# tween for going fully visible to totally dark and transparent
	$TweenDisappear.interpolate_property(self, "modulate", 
	self.modulate, Color(0, 0, 0, 0), 0.5, 
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$TweenDisappear.start()
