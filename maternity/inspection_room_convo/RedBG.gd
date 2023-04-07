extends TextureRect


func _ready():
	pass


func _on_Convo_tag(tag):
	if tag == "red_bg_appear":
		# tween for going fully visible to totally dark and transparent
		$TweenAppear.interpolate_property(self, "modulate", 
		self.modulate, Color(1, 1, 1, 1), 0.5, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		$TweenAppear.start()
	elif tag == "red_bg_darken":
		$TweenDarken.interpolate_property(self, "modulate", 
		self.modulate, Color(1, 0, 0, 1), 0.25, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		$TweenDarken.start()


func _on_TweenDarken_tween_completed(object, key):
	$TweenPartial.interpolate_property(self, "modulate", 
	self.modulate, Color(1, 0.5, 0.5, 1), 5, 
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$TweenPartial.start()


func _on_TweenPartial_tween_completed(object, key):
	$TweenDisappear.interpolate_property(self, "modulate", 
	self.modulate, Color(1, 1, 1, 0), 0.2, 
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$TweenDisappear.start()

