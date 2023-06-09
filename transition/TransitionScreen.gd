extends CanvasLayer

# to alert scene transition manager it's ok to switch scenes
signal transitioned


func _ready():
	pass


func transition():
	$AnimationPlayer.play("fade_to_black")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
