extends RichTextLabel

var highlighted_text = "[color=yellow]\u00AC Continue[/color]"
var unhighlighted_text = "\u00AC Continue"


func _ready():
	self.set_bbcode(highlighted_text)


func _on_FullRect_mouse_entered():
	self.set_bbcode(highlighted_text)


func _on_FullRect_mouse_exited():
	self.set_bbcode(unhighlighted_text)
