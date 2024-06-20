extends HBoxContainer

const jasper_line_1 = "You aren't safe here.  You're only safe if you listen to me."
const jasper_line_2 = "Why aren't you standing up?  This is why no one will ever love you."


func _ready():
	pass


func set_text(line_text: String):
	$TextLine.set_text(line_text)
	if line_text == jasper_line_1:
		$TextLine.set_font_size_small(24)
	if line_text == jasper_line_2:
		$TextLine.set_font_size_small(6)
	
