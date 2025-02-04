extends Area2D


var amelie_profiles = {
	"confused" : "res://conversation_pov/char_profiles/amelie/amelie_confused.png",
	"disgusted" : "res://conversation_pov/char_profiles/amelie/amelie_disgusted.png",
	"fuming" : "res://conversation_pov/char_profiles/amelie/amelie_fuming.png",
	"guilty" : "res://conversation_pov/char_profiles/amelie/amelie_guilty.png",
	"neutral" : "res://conversation_pov/char_profiles/amelie/amelie_neutral.png",
	"sad" : "res://conversation_pov/char_profiles/amelie/amelie_sad.png",
	"shocked" : "res://conversation_pov/char_profiles/amelie/amelie_shocked.png",
	"uncertain" : "res://conversation_pov/char_profiles/amelie/amelie_uncertain.png",
}

var wiggly_profiles = {
	"half_smile" : "res://conversation_pov/char_profiles/wiggly/wiggly_half_smile.png",
	"laughing" : "res://conversation_pov/char_profiles/wiggly/wiggly_laughing.png",
	"looking_to_side" : "res://conversation_pov/char_profiles/wiggly/wiggly_looking_to_side.png",
	"sad" : "res://conversation_pov/char_profiles/wiggly/wiggly_sad.png",
	"skeptical" : "res://conversation_pov/char_profiles/wiggly/wiggly_skeptical.png",
	"surprised" : "res://conversation_pov/char_profiles/wiggly/wiggly_surprised.png",
	"wincing" : "res://conversation_pov/char_profiles/wiggly/wiggly_wincing.png",
	"thinking" : "res://conversation_pov/char_profiles/wiggly/wiggly_thinking.png",
	"neutral" : "res://conversation_pov/char_profiles/wiggly/wiggly_neutral.png",
}

var julia_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/julia/julia_neutral.png",
	"amused" : "res://conversation_pov/char_profiles/julia/julia_amused.png",
	"concerned" : "res://conversation_pov/char_profiles/julia/julia_concerned.png",
	"lost_in_thought" : "res://conversation_pov/char_profiles/julia/julia_lost_in_thought.png",
	"reminiscing" : "res://conversation_pov/char_profiles/julia/julia_reminiscing.png",
	"sly" : "res://conversation_pov/char_profiles/julia/julia_sly.png",
	"suspicious" : "res://conversation_pov/char_profiles/julia/julia_suspiscious.png",
	"thinking" : "res://conversation_pov/char_profiles/julia/julia_thinking.png",
	"worried" : "res://conversation_pov/char_profiles/julia/julia_worried.png",
}

var jasper_profiles = {
	"neutral" : "res://conversation_pov/char_profiles/jasper/jasper_neutral.png",
	"head_tilted" : "res://conversation_pov/char_profiles/jasper/jasper_head_tilted.png",
	"looking_forward" : "res://conversation_pov/char_profiles/jasper/jasper_looking_forward.png",
	"surprised" : "res://conversation_pov/char_profiles/jasper/jasper_surprised.png",
	"sad" : "res://conversation_pov/char_profiles/jasper/jasper_sad.png",
	"turned_away" : "res://conversation_pov/char_profiles/jasper/jasper_turned_away.png",
	"twisted" : "res://conversation_pov/char_profiles/jasper/jasper_twisted.png",
	"thinking" : "res://conversation_pov/char_profiles/jasper/jasper_thinking.png",
}


var char_path_dict = {
	"Amelie" : amelie_profiles,
	"Wiggly" : wiggly_profiles,
	"Julia" : julia_profiles,
	"Jasper" : jasper_profiles,
}

var popup_done = false
var index = 0
var characters_array = []
var emotions_array = []
var text_array = []
var all_in_party = true
var perm_disabled = false
var popup_visible = false
var in_area = false

@export var popup_on_entry = false
@export var popup_text = [
	"Amelie,neutral::Example Text",
	"Wiggly,neutral::Wiggly Text"
]
@export var diff_background = false
@export var nav_popup_up = false
@export var nav_popup_right = false
@export var nav_popup_down = false
@export var nav_popup_left = false
# for single use popups to work we need to set a progression flag for them so
# we can remember if they've been invoked.
@export var single_use = false
@export var prog_flag = "None"
@export var steam_ach = "None"

@onready var popup = $HBoxContainer
@onready var label = $HBoxContainer/VBoxContainer/LabelContainer/Label
@onready var texture = $HBoxContainer/MarginContainer/TextureRect
@onready var typewriter = $TypewriterSounds
@onready var full_rect = $FullRect

signal disable_buttons
signal enable_buttons
signal swap_bg_signal
signal steam_achievement(ach_name)


func _ready():
	if single_use and Global.get_prog_flag(prog_flag):
		self.perm_disabled = true
	add_to_group("click_areas")
	add_to_group("popups")
	if diff_background:
		add_to_group("diff_bg")
	if nav_popup_up:
		add_to_group("nav_popups_up")
	if nav_popup_right:
		add_to_group("nav_popups_right")
	if nav_popup_down:
		add_to_group("nav_popups_down")
	if nav_popup_left:
		add_to_group("nav_popups_left")
	
	for pair in popup_text:
		var pair_array = pair.split("::")
		var char_array = pair_array[0].split(",")
		var char_name = char_array[0]
		var char_emotion = char_array[1]
		var text = pair_array[1]
		characters_array.append(char_name)
		emotions_array.append(char_emotion)
		text_array.append(text)

	if not self.popup_on_entry:
		popup.hide()
	else:
		self.advance_popup()
	
	all_in_party = _check_in_party()


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
	if all_in_party:
		if self.popup_done:
			if steam_ach != "None":
				if not Steam.getAchievement(steam_ach)["achieved"]:
					emit_signal("steam_achievement", steam_ach)
					Steam.setAchievement(steam_ach)
					Steam.storeStats()
	
			full_rect.input_pickable = false
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
				emit_signal("swap_bg_signal")
				await get_tree().create_timer(0.8).timeout
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


func _check_in_party():
	var in_party = true
	for character in characters_array:
		# can safely assume Amelie and Jasper always in party
		if character != "Amelie" and character != "Jasper":
			in_party = in_party and character in Global.party
	return in_party


func _show_next_text():
	self.typewriter.play()
	label.text = text_array[self.index]
	var char_emotion_dict = char_path_dict[characters_array[self.index]]
	texture.texture = load(char_emotion_dict[emotions_array[self.index]])
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
		in_area = true
		Global.set_cursor("mag_glass")


func _on_OnClickPopUp_mouse_exited():
	in_area = false
	Global.search_release_cursor()
		
		
func enable():
	self.input_pickable = true
		
		
func disable():
	self.input_pickable = false


