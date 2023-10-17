extends AudioStreamPlayer

@export var tag_to_play = ""
@export var play_once = false

var played = false


func _ready():
	pass


func check_tag(tag):
	if tag == tag_to_play:
		if not play_once:
			self.play()
		elif not played:
			self.play()
			played = true
