extends TextureRect

export var appear_tag = ""
export var disappear_tag = ""


func _ready():
	$TweenIn.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.3, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenOut.interpolate_property(self, "modulate", 
	  Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.3, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)


func _on_HBoxContainer_tag(tag):
	if tag == appear_tag:
		$TweenIn.start()
	elif tag == disappear_tag:
		$TweenOut.start()

