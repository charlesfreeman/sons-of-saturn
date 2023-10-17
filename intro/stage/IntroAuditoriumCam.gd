extends Camera2D

@onready var tween = create_tween()


func _ready():
	tween.tween_property(self, "zoom", Vector2(0.75, 0.75), 
	  30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)


func _on_Tween_tween_completed(object, key):
	await get_tree().create_timer(2.0).timeout
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("intro_convo", options, options, general_options)
