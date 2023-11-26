extends TextureRect

@onready var continue_button = $VBoxContainer/Continue
@onready var new_game_button = $VBoxContainer/NewGame
@onready var options_button = $VBoxContainer/Options
@onready var exit_button = $VBoxContainer/Exit
@onready var options_menu = $OptionsMenu


func _ready():
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.show_first_scene(options, general_options)
	Global.change_song("intro_music")
	
	# if no save files, disable "Continue" and hand focos over to "New Game"
	if not Global.check_save_exists():
		continue_button.change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))
		continue_button.disabled = true
		new_game_button.grab_focus()
	else:
		continue_button.grab_focus()


func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		if options_menu.visible:
			options_menu.visible = false
			get_tree().call_group("title_menu_opt", "show_option")


func _on_Exit_pressed():
	get_tree().quit()


func _on_exit_button_pressed():
	options_menu.visible = false
	get_tree().call_group("title_menu_opt", "show_option")


func _on_options_pressed():
	options_menu.visible = true
	get_tree().call_group("title_menu_opt", "hide_option")
	
