extends Button

@onready var label = $HBoxContainer/Label

signal stage_savegame(new_savegame)


# Called when the node enters the scene tree for the first time.
func _ready():
	if not Global.check_save_exists("user://sonsofsaturn.save"):
		self.disable()
		self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
	
	
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
	emit_signal("stage_savegame", "user://sonsofsaturn.save")


func disable():
	self.mouse_filter = MOUSE_FILTER_IGNORE


func enable():
	self.mouse_filter = MOUSE_FILTER_PASS 
