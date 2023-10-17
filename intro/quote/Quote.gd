extends TextureRect


func _ready():
	Global.change_song("None")
	Global.change_soundscape("FreshAir")
	await get_tree().create_timer(7.0).timeout
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("Stage", options, options, general_options)
