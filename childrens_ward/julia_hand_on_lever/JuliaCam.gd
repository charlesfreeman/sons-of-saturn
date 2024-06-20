extends Camera2D

signal swap_texture


func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	await tween.tween_property(self, "zoom", Vector2(1.05, 1.05), 20).finished
	self._on_tween_completed()


func _on_tween_completed():
	emit_signal("swap_texture")
	await get_tree().create_timer(25.0).timeout
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("final_convo", options, options, general_options)
