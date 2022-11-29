extends TextureRect


func _ready():
	Audio.get_node("AudioStreamPlayer").play()
	yield(get_tree().create_timer(7.0), "timeout")
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("Stage", options, options, general_options)
