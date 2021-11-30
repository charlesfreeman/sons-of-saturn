extends TextureRect

var times_hide_called: int = 0


func _ready():
	pass


func _on_PoV_gui_input(event):
	print("pov gui input")
	print(event)
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		$DollPopUp.hide()


func _on_Area2D_input_event(viewport, event, shape_idx):
	print("area2D event")
	print(event)
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		$DollPopUp.show()


func _on_FullRect_input_event(viewport, event, shape_idx):
	print("FullRect event")
	print(event)
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		# solves issue of both regions getting called when intercepting click
		# jank as hell, I really don't like this because of potential timing 
		# errors.  But it works for now.
		if self.times_hide_called == 1:
			$DollPopUp.hide()
			self.times_hide_called = 0
		else:
			self.times_hide_called += 1
