extends VBoxContainer

onready var speaker_name = $SpeakerName
onready var dialogue_line = $TextLine/DialogueLine

# for associating the char with the right color
# TODO remove "Wigley"
var char_colors = {"Wigley": "aqua", 
	"Wiggly": "aqua",
	"Ferryman": "aqua", 
	"You": "red", 
	"Tann": "fuchsia", 
	"Ansel": "blue",
	"Vera": "green",
	"Robert" : "fuchsia",
	"Leslie" : "blue",
	"Note" : "white",
	"Frail Woman": "purple",
	"Julia": "purple",
	"Voice": "green",
	"Malformed Lump": "green",
	"Jasper": "green",
	"Dead Cat": "grey"
}


func _ready():
	pass


func set_speaker_name(char_name):
	var char_color = self.char_colors[char_name]
	# onready var's don't seem to be working, must resort to direct reference
	# probably a timing issue?
	$SpeakerName.append_bbcode("[color=%s]"%char_color+char_name+"[/color]")
	
	
func set_dialogue_line(text):
	$TextLine/DialogueLine.text = text


func make_grey():
	self.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
