extends Button

@onready var label = $HBoxContainer/Label

signal new_save_button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func change_color(color: Color):
	label.add_theme_color_override("font_color", color)


func _on_focus_entered():
	change_color(Color(1,1,0,1))


func _on_focus_exited():
	change_color(Color(1,1,1,1))


func _on_mouse_entered():
	self.grab_focus()


func _on_mouse_exited():
	self.release_focus()


func _on_pressed():
	Global.save_game()
	emit_signal("new_save_button")


func disable():
	self.mouse_filter = MOUSE_FILTER_IGNORE


func enable():
	self.mouse_filter = MOUSE_FILTER_PASS 
