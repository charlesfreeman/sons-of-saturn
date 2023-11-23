extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_audio_stream_player_finished():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("Stage", options, options, general_options)
