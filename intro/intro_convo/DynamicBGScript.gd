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
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.4)
	if tag.begins_with("bg") and is_visible:
		global_tag = tag
		# play sound effect
		$SwitchFlipSlow.play()
		# tween for going fully visible to totally dark and transparent
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		await tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.4).finished
		is_visible = false
		self._on_tweendark_completed()


# if intercepted tag matches exported var, make this bg visible
func new_bg(tag):
	if tag == new_bg_tag:
		is_visible = true
		# play sound effect
		$SwitchFlipFast.play()
		# tween for going totally dark to fully visible
		var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.4)


func _on_tweendark_completed():
	# hacky "wait around and do nothing" tween
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	await tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.25).finished
	get_tree().call_group("DynamicBGs", "new_bg", global_tag)
