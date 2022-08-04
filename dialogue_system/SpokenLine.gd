extends VBoxContainer

onready var speaker_name = $SpeakerName
onready var dialogue_line = $DialogueLine

# for associating the char with the right color
var char_colors = {"Wigley": "aqua", 
	"Ferryman": "aqua", 
	"You": "red", 
	"Tann": "fuchsia", 
	"Ansel": "blue",
	"Vera": "green",
	"Voice": "aqua",
}

signal change_char(character)


func _ready():
	pass


func set_speaker_name(char_name):
	var char_color = self.char_colors[char_name]
	# onready var's don't seem to be working, must resort to direct reference
	# probably a timing issue?
	$SpeakerName.append_bbcode("[color=%s]"%char_color+char_name+"[/color]")
	
	
func set_dialogue_line(text):
	$DialogueLine.text = text
