extends Area2D

var in_clickable_area = false
var popup_done = false
var index = 0
var enabled = true
var perm_disabled = false
var popup_visible = false

onready var popup = $VBoxContainer
onready var label = $VBoxContainer/LabelContainer/Label
onready var typewriter = $RanSoundContainer

export var popup_on_entry = false
export var popup_text = ["example text for popup", "example 2"]
export var diff_background = false
export var nav_popup = false
# for single use popups to work we need to set a progression flag for them so
# we can remember if they've been invoked.
export var single_use = false
export var prog_flag = "None"
export var new_item = "None"

signal disable_buttons
signal enable_buttons
signal swap_bg
signal new_item(item)


func _ready():
	if single_use and Global.get_prog_flag(prog_flag):
		self.perm_disabled = true
	add_to_group("click_areas")
	add_to_group("popups")
	if diff_background:
		add_to_group("diff_bg")
	if nav_popup:
		add_to_group("nav_popups")
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
			if prog_flag != "None":
				Global.flip_prog_flag(prog_flag)
				if single_use:
					self.perm_disabled = true
			popup.hide()
			self.popup_done = false
			Global.set_cursor("null")
			get_tree().call_group("click_areas", "enable")
			emit_signal("enable_buttons")
			if diff_background:
				emit_signal("swap_bg")
			if new_item != "None":
				emit_signal("new_item", new_item)
		elif (self.in_clickable_area and self.enabled and not self.perm_disabled) or self.index != 0:
			progress_popup()


func progress_popup():
	get_tree().call_group("click_areas", "disable")
	Global.set_cursor("cont_sym")
	if self.index == 0:
		# if we have an audiostreamplayer as a child, invoke it
		if has_node("./AudioStreamPlayer"):
			get_node("./AudioStreamPlayer").play()
			emit_signal("disable_buttons")
		if diff_background:
			emit_signal("swap_bg")
	self._show_next_text()


func _show_next_text():
	self.typewriter.play()
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
	if self.enabled and not self.perm_disabled:
		self.in_clickable_area = true
		Global.set_cursor("mag_glass")


func _on_OnClickPopUp_mouse_exited():
	self.in_clickable_area = false
	if self.enabled and not self.perm_disabled:
		Global.set_cursor("null")
		
		
func enable():
	print("enabling")
	self.enabled = true
		
		
func disable():
	print("disabling")
	self.enabled = false
