extends TextureButton

@onready var label_node = $HBoxContainer/OptionText

var button_text
var next_passage
var clicked: bool = false
var progression_button: bool = false
var continue_mode: bool = false
var mode_set: bool = false

signal play_click


func _ready():
	pass 
	

# method to unpack button label text, next passage identifier, button 
# modifiers, and other info from the link text.  Previously some of this labor 
# was performed by the VBoxContainer script but decided it made more sense to 
# shuffle this labor off to the buttons
func extract_text_and_modifiers(text: String):
	# the four things we need.  Button text eventually split into 
	# button_text_minus_mods and modifiers.  link_text and next_passage_name
	# may or may not be identical depending on context
	var link_text
	var next_passage_name
	var modifiers
	var button_text_minus_mods
	
	if "->" in text:
		var text_array = text.split("->")
		link_text = text_array[0]
		next_passage_name = text_array[1]
	else:
		link_text = text
		next_passage_name = text

	set_next_passage(next_passage_name)
	
	if ":" in link_text:
		var text_array = link_text.split(":")
		modifiers = text_array[0]
		button_text_minus_mods = text_array[1]
	else:
		modifiers = ""
		button_text_minus_mods = link_text
		
	if "p" in modifiers:
		set_as_progression()
	
	set_label_text(_insert_newlines(button_text_minus_mods))
	
	var num_newlines = len(label_node.text.split("\n"))
	self.custom_minimum_size.y = num_newlines * 64
	label_node.custom_minimum_size.y = num_newlines * 64
	
	if self.progression_button:
		change_color(Color(1, 0.5, 0, 1))
	elif self.clicked:
		change_color(Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1))


func _insert_newlines(text: String) -> String:
	var line_length = 47
	if text.length() >= line_length:
		var index = line_length
		while index < text.length():
			while text[index] != " ":
				index -= 1
			index += 1
			text = text.insert(index, "\n")
			index += 1
			index += 1
			index += line_length
	return text
 

func set_label_text(text: String):
	if text == "Continue" or text == "C":
		self.button_text = "\u00AC Continue"
		self.continue_mode = true
		$HBoxContainer.set("theme_override_constants/separation", 50)
	else:
		self.button_text = text
	self.mode_set = true
	label_node.text = self.button_text
	

# set the number preceding the option
func set_opt_number(num: int):
	var num_label = $HBoxContainer/Control/OptNumber
	assert(self.mode_set)
	if not self.continue_mode:
		num_label.text = "%s)."%num
	else:
		num_label.text = ""


func set_as_clicked():
	self.clicked = true


func change_color(color: Color):
	label_node.add_theme_color_override("font_color", color)


func set_as_progression():
	self.progression_button = true
	

# sets the text to load the next block with
func set_next_passage(text: String):
	self.next_passage = text


func get_text() -> String:
	return self.button_text


func get_next_passage() -> String:
	return self.next_passage


func _on_DialogueOption_focus_entered():
	label_node.add_theme_color_override("font_color", Color(1,1,0,1))


func _on_DialogueOption_focus_exited():
	if not self.progression_button:
		if not self.clicked:
			change_color(Color(1, 1, 1, 1))
		else:
			change_color(Color(0.75, 0.75, 0.75, 1))
	else:
		# change color to orange
		change_color(Color(1, 0.5, 0, 1))


func _on_DialogueOption_mouse_entered():
	self.grab_focus()


func _on_DialogueOption_mouse_exited():
	self.release_focus()


func _on_DialogueOption_pressed():
	emit_signal("play_click")

