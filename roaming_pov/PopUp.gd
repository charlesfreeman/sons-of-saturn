extends Area2D

var char_path_dict = {
	"Rando": "res://images/gas_mask_cropped_no_marquee.png",
	"Wiggly" : "res://images/wigley_headshot_feathered.png",
	"Amelie" : "res://images/amelie_270x360_no_mirror.png",
}
var in_clickable_area = false
var popup_done = false
var index = 0
var characters_array = []
var text_array = []
var all_in_party = false
var enabled = true
var popup_visible = false

export var popup_on_entry = false
export var popup_text = [
	"Amelie::Example Text",
	"Wiggly::Wiggly Text"
]
export var diff_background = false
export(String, FILE) var popup_texture = "None"

onready var popup = $HBoxContainer
onready var label = $HBoxContainer/VBoxContainer/LabelContainer/Label
onready var texture = $HBoxContainer/MarginContainer/TextureRect
onready var mag_glass = load("res://roaming_pov/images/mag_glass.png")
onready var cont_sym = load("res://images/cont_arrow.png")

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
	for pair in popup_text:
		var pair_array = pair.split("::")
		var char_name = pair_array[0]
		var text = pair_array[1]
		characters_array.append(char_name)
		text_array.append(text)
	all_in_party = _check_in_party()


func _on_FullRect_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if all_in_party:
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


func _check_in_party():
	var in_party = true
	for character in characters_array:
		in_party = in_party and character in Global.party
	return in_party


func _show_next_text():
	label.text = text_array[self.index]
	texture.texture = load(char_path_dict[characters_array[self.index]])
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
