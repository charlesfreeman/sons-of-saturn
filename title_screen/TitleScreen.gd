extends TextureRect


func _ready():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.show_first_scene(options, general_options)
