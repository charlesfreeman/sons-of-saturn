extends Area2D

var popup_done = false
var index = 0
var perm_disabled = false
var popup_visible = false
var in_area = false

@onready var popup = $VBoxContainer
@onready var label = $VBoxContainer/LabelContainer/Label
@onready var typewriter = $TypewriterSounds
@onready var full_rect = $FullRect

@export var popup_on_entry = false
@export var popup_text = ["example text for popup", "example 2"]
@export var diff_background = false
@export var nav_popup = false
# for single use popups to work we need to set a progression flag for them so
# we can remember if they've been invoked.
@export var single_use = false
@export var prog_flag = "None"
@export var new_item = "None"

signal disable_buttons
signal enable_buttons
signal swap_bg_signal
signal new_item_signal(item)
signal steam_achievement(ach_name)


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
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		progress_popup()
		

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		if in_area:
			advance_popup()
		else:
			progress_popup()


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if not self.perm_disabled:
			advance_popup()


func progress_popup():
	if self.popup_done:
		Global.set_cursor("null")
		full_rect.input_pickable = false
		if prog_flag != "None":
			Global.flip_prog_flag(prog_flag)
			if single_use:
				self.perm_disabled = true
		popup.hide()
		self.popup_done = false
		if diff_background:
			emit_signal("swap_bg_signal")
			await get_tree().create_timer(0.8).timeout
		if new_item != "None":
			emit_signal("new_item_signal", new_item)
		get_tree().call_group("click_areas", "enable")
		emit_signal("enable_buttons")
	elif self.index != 0:
		advance_popup()


func advance_popup():
	get_tree().call_group("click_areas", "disable")
	emit_signal("disable_buttons")
	Global.set_cursor("cont_sym")
	if self.index == 0:
		# if we have an audiostreamplayer as a child, invoke it
		if has_node("./AudioStreamPlayer"):
			get_node("./AudioStreamPlayer").play()
		if diff_background:
			emit_signal("swap_bg_signal")
	self._show_next_text()
	if diff_background and self.index == 0:
		await get_tree().create_timer(0.8).timeout
	full_rect.input_pickable = true


func _show_next_text():
	self.typewriter.play()
	label.text = popup_text[self.index]
	if not (self.diff_background and self.index == 0):
		popup.show()
	self.index += 1
	if self.index == len(popup_text):
		self.popup_done = true
		self.index = 0


func _make_visible():
	if not popup_visible:
		popup.show()
		popup_visible = true
	else:
		popup_visible = false


func _on_OnClickPopUp_mouse_entered():
	if not self.perm_disabled:
		self.in_area = true
		Global.set_cursor("mag_glass")


func _on_OnClickPopUp_mouse_exited():
	self.in_area = false
	Global.search_release_cursor()
		
		
func enable():
	self.input_pickable = true
		
		
func disable():
	self.input_pickable = false


