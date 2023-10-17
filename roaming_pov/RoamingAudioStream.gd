extends AudioStreamPlayer

@export var sound_files = []

var i = 0
var num_sounds

func _ready():
	num_sounds = len(sound_files)
	
	
func play_next_sound():
	print("playing sound")
	self.set_stream(load(sound_files[i]))
	i = (i+1) % num_sounds
	self.play()
