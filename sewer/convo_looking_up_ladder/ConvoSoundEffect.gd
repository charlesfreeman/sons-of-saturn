extends AudioStreamPlayer

export var tag_to_play = ""


func _ready():
	pass


func check_tag(tag):
	if tag == tag_to_play:
		self.play()
