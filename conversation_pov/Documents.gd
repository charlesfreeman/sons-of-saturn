extends TextureRect

export var docs = []

# assuming we're never going to have a document longer than 9 pages
var indexes = [1, 2, 3, 4, 5, 6, 7, 8, 9]

onready var convo = get_parent().get_node("Convo")

func _ready():
	convo.connect("tag", self, "_on_Convo_tag")


func _on_Convo_tag(tag):
	var index = int(tag)
	if index in indexes:
		# indices start at 1 instead of zero because the int function returns
		# zero if no match is found, want to avoid this leading to the popup
		# of a document.  
		self.texture = load(docs[index-1])
