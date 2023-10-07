extends TextureRect

export var on_start = false
export var dark_on_start = false
export var appear_tag = ""
export var disappear_tag = ""
export var disappear_slow_tag = ""
export var brighten_tag = ""
export var darken_tag = ""
export var appear_dark_tag = ""


func _ready():
	# tween from going transparent to fully visible
	$TweenIn.interpolate_property(self, "modulate", 
	  self.modulate, Color(1, 1, 1, 1), 0.3, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween for going visible to fully transparent
	$TweenOut.interpolate_property(self, "modulate", 
	  self.modulate, Color(1, 1, 1, 0), 0.2, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# same thing but slower
	$TweenOutSlow.interpolate_property(self, "modulate", 
	  self.modulate, Color(1, 1, 1, 0), 1, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween for going fully visible
	$TweenBrighten.interpolate_property(self, "modulate", 
	  self.modulate, Color(1, 1, 1, 1), 0.3, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween for going fully visible to mostly dark
	$TweenDarken.interpolate_property(self, "modulate", 
	  self.modulate, Color(0.1, 0.1, 0.1, 1), 0.2, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# tween for going transparent to mostly dark
	$TweenAppearDark.interpolate_property(self, "modulate", 
	  Color(0, 0, 0, 0), Color(0.35, 0.35, 0.35, 1), 0.8, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	# might want to add dark -> tranparent tween at some point but not yet needed
	if on_start:
		$TweenIn.start()
	elif dark_on_start:
		$TweenAppearDark.start()


func appear_disappear(tag):
	match tag:
		appear_tag:
			$TweenIn.start()
		disappear_tag:
			$TweenOut.start()
		disappear_slow_tag:
			$TweenOutSlow.start()
		brighten_tag:
			$TweenBrighten.start()
		darken_tag:
			$TweenDarken.start()
		appear_dark_tag:
			$TweenAppearDark.start()
