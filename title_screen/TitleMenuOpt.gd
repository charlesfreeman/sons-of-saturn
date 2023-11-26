extends Button

@export var label_text = ""

@onready var label = $Label


func _ready():
	label.text = label_text
	

func change_color(color: Color):
	label.add_theme_color_override("font_color", color)


func _on_TitleMenuOpt_focus_entered():
	if not self.disabled:
		change_color(Color(1,1,0,1))


func _on_TitleMenuOpt_focus_exited():
	if not self.disabled:
		change_color(Color(1, 1, 1, 1))


func _on_TitleMenuOpt_mouse_entered():
	self.grab_focus()


func _on_TitleMenuOpt_mouse_exited():
	self.release_focus()


func _on_Continue_pressed():
	Global.load_game()


func _on_NewGame_pressed():
	Global.change_song("None")
	Global.change_song("fresh_air")
	Global.reset_prog_flags()
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("Stage", options, options, general_options)


func hide_option():
	self.visible = false


func show_option():
	self.visible = true
