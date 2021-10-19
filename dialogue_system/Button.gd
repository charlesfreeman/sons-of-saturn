extends Button

var button_text


# Hide button by default
func _ready():
	self.hide()


# Method to set the text of the button
# Also stores text as a variable, for use in grabbing twison passages
func set_text(text: String):
	self.button_text = text
	$RichTextLabel.set_bbcode(text)
	
	
# highlight the focused text
func highlight_text():
	var highlighted_text = "[color=yellow]" + self.button_text + "[/color]"
	$RichTextLabel.set_bbcode(highlighted_text)


# dehighlight the text when focus moved
func dehighlight_text():
	print("dehighlighting")
	$RichTextLabel.set_bbcode(self.button_text)
