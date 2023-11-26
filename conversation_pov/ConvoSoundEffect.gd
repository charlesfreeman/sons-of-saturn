extends AudioStreamPlayer

@export var tag_to_play = ""
@export var play_once = false

@onready var base_volume = self.volume_db

var played = false


func _ready():
	self.reduce_volume()


func check_tag(tag):
	if tag == tag_to_play:
		if not play_once:
			self.play()
		elif not played:
			self.play()
			played = true


# expect sound_effect_vol to be some value between -50 and 0, determined by player
func reduce_volume():
	self.volume_db = base_volume + Global.sound_effect_vol
