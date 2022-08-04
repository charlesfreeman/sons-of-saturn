extends Area2D

var in_clickable_area = false
var popup_done = false
var index = 0
var enabled = true
var popup_visible = false

onready var popup = $VBoxContainer
onready var label = $VBoxContainer/LabelContainer/Label
onready var cont_sym = load("res://images/cont_arrow.png")
onready var mag_glass = load("res://roaming_pov/images/mag_glass.png")

export var popup_on_entry = false
export var popup_text = ["example text for popup", "example 2"]
export var diff_background = false

signal disable_buttons
signal enable_buttons
signal swap_bg


func _ready():
	add_to_group("click_areas")
	add_to_group("popups")
	if diff_background:
		add_to_group("diff_bg")
	if not self.popup_on_entry:
		popup.hide()
	else:
		self._show_next_text()
	$VBoxContainer/LabelContainer/Label.text = popup_text[0]


func _on_FullRect_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if self.popup_done:
			popup.hide()
			self.popup_done = false
			Input.set_custom_mouse_cursor(null)
			get_tree().call_group("click_areas", "enable")
			emit_signal("enable_buttons")
			if diff_background:
				emit_signal("swap_bg")
		elif (self.in_clickable_area and self.enabled) or self.index != 0:
			get_tree().call_group("click_areas", "disable")
			Input.set_custom_mouse_cursor(cont_sym)
			if self.index == 0:
				emit_signal("disable_buttons")
				if diff_background:
					emit_signal("swap_bg")
			self._show_next_text()


func _show_next_text():
	label.text = popup_text[self.index]
	if not (self.diff_background and self.index == 0):
		popup.show()
	self.index += 1
	if self.index == len(popup_text):
		self.popup_done = true
		self.index = 0


func make_visible():
	if not popup_visible:
		popup.show()
		popup_visible = true
	else:
		popup_visible = false


func _on_OnClickPopUp_mouse_entered():
	if self.enabled:
		self.in_clickable_area = true
		Input.set_custom_mouse_cursor(mag_glass)


func _on_OnClickPopUp_mouse_exited():
	self.in_clickable_area = false
	if self.enabled:
		Input.set_custom_mouse_cursor(null)
		
		
func enable():
	self.enabled = true
		
		
func disable():
	self.enabled = false
