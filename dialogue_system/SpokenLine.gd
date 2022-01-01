extends VBoxContainer

# for associating the char with the right color
var char_colors = {"Wigley": "aqua", "You": "red", "Georgia": "blue"}
# for keeping track of current character speaking
var current_char: String = "None"

signal change_char(character)

func _ready():
	pass


func set_speaker_name(char_name):
	if char_name != self.current_char:
		emit_signal("change_char", char_name)
		self.current_char = char_name
	var char_color = self.char_colors[char_name]
	$SpeakerName.append_bbcode("\n[color=%s]"%char_color+char_name+"[/color]")
	
	
func set_dialogue_line(text):
	$SpokenLineNoChar.set_text(text)
