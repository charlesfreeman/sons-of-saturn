extends Area2D

var char_path_dict = {
	"Rando": "res://images/gas_mask_cropped_no_marquee.png"
}
var in_clickable_area = false
var popup_done = false
var index = 0

export var popup_on_entry = false
onready var popup = $HBoxContainer
onready var label = $HBoxContainer/Control/Label

export var popup_image_char = "Rando"
export var popup_text = ["example text for popup", "example 2"]
export(NodePath) var my_collision_polygon_node_path


func _ready():
	add_child(get_node(my_collision_polygon_node_path).duplicate())
	if not self.popup_on_entry:
		popup.hide()
	else:
		self._show_next_text()
	$HBoxContainer/MarginContainer/TextureRect.texture = load(char_path_dict[popup_image_char])
	$HBoxContainer/Control/Label.text = popup_text[0]


func _on_FullRect_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if popup_image_char in Global.party:
			if self.popup_done:
				popup.hide()
				self.popup_done = false
			elif self.index != 0 or self.in_clickable_area:
				self._show_next_text()


func _show_next_text():
	label.text = popup_text[self.index]
	popup.show()
	self.index += 1
	if self.index == len(popup_text):
		self.popup_done = true
		self.index = 0
	


func _on_OnClickPopUp_mouse_entered():
	print("entered clickable area")
	self.in_clickable_area = true


func _on_OnClickPopUp_mouse_exited():
	print("exited clickable area")
	self.in_clickable_area = false
