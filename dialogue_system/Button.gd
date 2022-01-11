extends TextureButton

onready var label_node = $OptionText

var button_text
var next_passage
var progression_button: bool = false
var continue_mode: bool = false

signal play_click


# Hide button by default
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
		print("splitting link")
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
		print("setting as progression")
		set_as_progression()
	
	set_label_text(button_text_minus_mods)
	
	label_node.set_bbcode(self.button_text)
	print("num newlines: ", len(label_node.bbcode_text.split("\n", true)))
	self.rect_size.y = label_node.rect_size.y
	if self.progression_button:
		change_color("red")


func set_label_text(text: String):
	if text == "Continue":
		self.button_text = "\u00AC Continue"
		self.continue_mode = true
	else:
		self.button_text = text
	

func change_color(color: String):
	print("changing color - ", color)
	var highlighted_text = "[color=%s]"%color + self.button_text + "[/color]"
	label_node.set_bbcode(highlighted_text)


func set_as_progression():
	self.progression_button = true
	

# sets the text to load the next block with
func set_next_passage(text: String):
	print("setting next passage: ", text)
	self.next_passage = text


func get_text() -> String:
	return self.button_text


func get_next_passage() -> String:
	return self.next_passage


func _on_DialogueOption_focus_entered():
	change_color("yellow")


func _on_DialogueOption_focus_exited():
	if not self.progression_button:
		label_node.set_bbcode(self.button_text)
	else:
		change_color("red")


func _on_DialogueOption_mouse_entered():
	self.grab_focus()


func _on_DialogueOption_pressed():
	emit_signal("play_click")
