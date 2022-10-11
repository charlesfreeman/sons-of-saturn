extends TextureRect


func _ready():
	yield(get_tree().create_timer(7.0), "timeout")
	
	SceneManager.change_scene("res://intro/stage/Stage.tscn")
