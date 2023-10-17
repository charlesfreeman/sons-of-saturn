extends Camera2D

@onready var tween = $Tween


func _ready():
	tween.interpolate_property(self, "zoom", Vector2(1, 1), Vector2(0.75, 0.75), 30, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 2)
	tween.start()


func _on_Tween_tween_completed(object, key):
	await get_tree().create_timer(2.0).timeout
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("intro_convo", options, options, general_options)
