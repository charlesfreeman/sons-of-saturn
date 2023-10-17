extends TextureRect

# tag for transferring to this background
@export var new_bg_tag = ""
# set this to true for the first bg, for all others leave as is
# internal methods manipulate this as well
@export var is_visible = false


var global_tag = ""
var d_level = 0.3


func _ready():
	pass


# intercepts all "bg" tags, if the current bg is visible this func darkens 
# to make room for the next one.
func appear_disappear(tag):
	# special case so might as well hardcode
	if tag == "brighten_stage" and self.name == "DynamicBG":
		$TweenMostlyDarkToBright.interpolate_property(self, "modulate", 
		  self.modulate, Color(1, 1, 1, 1), 0.4, 
		  Tween.TRANS_LINEAR, Tween.EASE_IN)
		$TweenMostlyDarkToBright.start()
	if tag.begins_with("bg") and is_visible:
		global_tag = tag
		print("darkening bg")
		# play sound effect
		$SwitchFlipSlow.play()
		# tween for going fully visible to totally dark and transparent
		$TweenTotalDarken.interpolate_property(self, "modulate", 
		self.modulate, Color(0, 0, 0, 0), 0.75, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		$TweenTotalDarken.start()
		is_visible = false


# if intercepted tag matches exported var, make this bg visible
func new_bg(tag):
	print("new_bg_tag: ", new_bg_tag)
	if tag == new_bg_tag:
		print("brightening bg")
		is_visible = true
		# play sound effect
		$SwitchFlipFast.play()
		# tween for going totally dark to fully visible
		$TweenTotalBrighten.interpolate_property(self, "modulate", 
		  self.modulate, Color(1, 1, 1, 1), 0.4, 
		  Tween.TRANS_EXPO, Tween.EASE_OUT)
		$TweenTotalBrighten.start()


func _on_TweenTotalDarken_tween_completed(_object, _key):
	print("dark tween completed")
	# hacky "wait around and do nothing" tween
	$TweenWaitDark.interpolate_property(self, "modulate", 
	  Color(0, 0, 0, 0), Color(0, 0, 0, 0), 0.25, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN)
	$TweenWaitDark.start()


func _on_TweenDark_tween_completed(_object, _key):
	get_tree().call_group("DynamicBGs", "new_bg", global_tag)
