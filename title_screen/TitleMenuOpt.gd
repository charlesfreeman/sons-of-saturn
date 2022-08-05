extends Button

export var label_text = ""

onready var label = $Label


func _ready():
	label.text = label_text
	

func change_color(color: Color):
	label.add_color_override("font_color", color)


func _on_TitleMenuOpt_focus_entered():
	label.add_color_override("font_color", Color(1,1,0,1))


func _on_TitleMenuOpt_focus_exited():
	change_color(Color(1, 1, 1, 1))


func _on_TitleMenuOpt_mouse_entered():
	self.grab_focus()


func _on_Continue_pressed():
	Global.load_game()


func _on_NewGame_pressed():
	SceneManager.change_scene("res://sewer/convo_looking_up_well/bottom_of_well.tscn")

