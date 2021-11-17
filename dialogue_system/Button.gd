extends TextureButton

var button_text
var next_passage


# Hide button by default
func _ready():
	self.hide()


# Method to set the text of the button
# Also stores text as a variable, for use in grabbing twison passages
func set_text(text: String):
	self.button_text = text
	# assumes you want the next passage to be the same as the button text
	# call the method below AFTER this one if this is not desired
	self.next_passage = text
	$OptionText.set_bbcode(text)
	

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
