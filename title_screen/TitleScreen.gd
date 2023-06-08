extends TextureRect

onready var continue_button = $VBoxContainer/Continue
onready var load_button = $VBoxContainer/LoadGame
onready var options_button = $VBoxContainer/Options


func _ready():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.show_first_scene(options, general_options)
	Global.change_song("intro_music")
	
	if not Global.check_save_exists():
		continue_button.change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))
		continue_button.disabled = true
	
	# disable load and options buttons for now, until implementations done
	load_button.disabled = true
	load_button.change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))
	options_button.disabled = true
	options_button.change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))


func _on_Exit_pressed():
	get_tree().quit()
