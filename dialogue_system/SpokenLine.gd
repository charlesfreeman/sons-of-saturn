extends VBoxContainer

@onready var speaker_name = $SpeakerName
@onready var dialogue_line = $TextLine/DialogueLine

# for associating the char with the right color
# TODO remove "Wigley"
var char_colors = {"Wigley": "aqua", 
	"Wiggly": "aqua",
	"Ferryman": "aqua", 
	"You": "red", 
	"Amelie": "red",
	"Tann": "fuchsia", 
	"Ansel": "blue",
	"Vera": "green",
	"Robert" : "fuchsia",
	"Leslie" : "blue",
	"Frost" : "crimson",
	"Note" : "white",
	"Frail Woman": "purple",
	"Julia": "purple",
	"Muffled Voice": "purple",
	"Voice": "green",
	"Malformed Lump": "green",
	"Jasper": "green",
	"Dead Cat": "grey",
	"Giant Rat": "light_salmon",
	"Rasping Voice": "light_salmon",
	"Ivory Woman": "fuchsia",
	"Mom": "ivory",
}


func _ready():
	if Global.retro_font_mode:
		$SpeakerName.visible = false


func set_speaker_name(char_name):
	var char_color = self.char_colors[char_name]
	# onready var's don't seem to be working, must resort to direct reference
	# probably a timing issue?
	$SpeakerName.text = "[color=%s]"%char_color+char_name+"[/color]"
	
	
func set_dialogue_line(text):
	$TextLine/DialogueLine.text = text
	$SpeakerName.set_font_size()
	$TextLine/DialogueLine.set_font_size()

