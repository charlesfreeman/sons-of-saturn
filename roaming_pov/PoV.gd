extends TextureRect

export(String, FILE) var scene_up = "None"
export(String, FILE) var scene_right = "None"
export(String, FILE) var scene_down = "None"
export(String, FILE) var scene_left = "None"

var times_hide_called: int = 0


func _ready():
	pass


func _on_FullRect_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		# solves issue of both regions getting called when intercepting click
		# jank as hell, I really don't like this because of potential timing 
		# errors.  But it works for now.
		if self.times_hide_called == 1:
			get_tree().call_group("popups", "hide_popup")
			self.times_hide_called = 0
		else:
			self.times_hide_called += 1


