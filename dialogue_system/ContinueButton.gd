extends TextureButton

var button_text : String
var next_passage : String
var load_block_mode : bool = false

signal play_click

# Hide button by default
func _ready():
	self.hide()
	self.button_text = "\u00AC Continue"


# Method to set the text of the button
# Also stores text as a variable, for use in grabbing twison passages
func set_next_passage(text: String):
	self.next_passage = text


func get_next_passage() -> String:
	return self.next_passage


func _on_ContinueButton_focus_entered():
	var highlighted_text = "[color=yellow]" + self.button_text + "[/color]"
	print(highlighted_text)
	$OptionText.set_bbcode(highlighted_text)


func _on_ContinueButton_focus_exited():
	$OptionText.set_bbcode(self.button_text)


func _on_ContinueButton_mouse_entered():
	self.grab_focus()


func _on_ContinueButton_pressed():
	emit_signal("play_click")
