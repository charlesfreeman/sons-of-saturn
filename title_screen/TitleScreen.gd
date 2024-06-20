extends TextureRect

@onready var continue_button = $VBoxContainer/Continue
@onready var new_game_button = $VBoxContainer/NewGame
@onready var options_button = $VBoxContainer/Options
@onready var exit_button = $VBoxContainer/Exit
@onready var options_menu = $OptionsMenu
@onready var saveload = $SaveLoad
@onready var load_game_option = $SaveLoad/LoadGameOption
@onready var delete_game_option = $SaveLoad/DeleteGameOption


func _ready():
	if Global.get_prog_flag("finished_game"):
		self.texture = load("res://title_screen/title_screen_w_jasper.png")
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.show_first_scene(options, general_options)
	Global.change_song("intro_music")
	
	# if no autosave file, disable "Continue" and hand focos over to "New Game"
	if not Global.check_save_exists("user://sonsofsaturn.save"):
		continue_button.change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))
		continue_button.disabled = true
		new_game_button.grab_focus()
	else:
		continue_button.grab_focus()


func _input(_event):
	if Input.is_action_pressed("ui_cancel"):
		if load_game_option.visible:
			load_game_option.visible = false
			saveload.enable_savegames()
		elif delete_game_option.visible:
			delete_game_option.visible = false
			saveload.enable_savegames()
		elif options_menu.visible:
			options_menu.visible = false
			get_tree().call_group("title_menu_opt", "show_option")
		elif saveload.visible:
			saveload.visible = false
			get_tree().call_group("title_menu_opt", "show_option")


func _on_Exit_pressed():
	get_tree().quit()


func _on_exit_button_pressed():
	options_menu.visible = false
	get_tree().call_group("title_menu_opt", "show_option")


func _on_options_pressed():
	get_tree().call_group("title_menu_opt", "hide_option")
	options_menu.visible = true
	

func _on_save_load_pressed():
	get_tree().call_group("title_menu_opt", "hide_option")
	saveload.visible = true


func _on_saveload_exit_button_pressed():
	saveload.visible = false
	get_tree().call_group("title_menu_opt", "show_option")
