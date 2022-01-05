extends TextureButton

var button_text
var next_passage
var progression_button: bool = false


# Hide button by default
func _ready():
	self.hide()


# method to unpack button label text, next passage identifier, button 
# modifiers, and other info from the link text.  Previously some of this labor 
# was performed by the VBoxContainer script but decided it made more sense to 
# shuffle this labor off to the buttons
func extract_text_and_modifiers(text: String):
	# the four things we need.  Button text eventually split into 
	# button_text_minus_mods and modifiers.  button_text and next_passage_name
	# may or may not be identical depending on context
	var next_passage_name
	var modifiers
	var button_text_minus_mods
	
	if "->" in text:
		print("splitting link")
		var text_array = text.split("->")
		button_text = text_array[0]
		next_passage_name = text_array[1]
	else:
		button_text = text
		next_passage_name = text

	set_next_passage(next_passage_name)
	
	if ":" in button_text:
		var text_array = button_text.split(":")
		modifiers = text_array[0]
		button_text_minus_mods = text_array[1]
	else:
		modifiers = ""
		button_text_minus_mods = text
		
	if "p" in modifiers:
		print("setting as progression")
		set_as_progression()
	
	set_label_text(button_text_minus_mods)


func set_label_text(text: String):
	self.button_text = text
	if self.progression_button:
		var highlighted_text = "[color=red]" + text + "[/color]"
		$OptionText.set_bbcode(highlighted_text)
	else:
		$OptionText.set_bbcode(text)
	

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
	var highlighted_text = "[color=yellow]" + self.button_text + "[/color]"
	$OptionText.set_bbcode(highlighted_text)


func _on_DialogueOption_focus_exited():
	$OptionText.set_bbcode(self.button_text)


func _on_DialogueOption_mouse_entered():
	self.grab_focus()
