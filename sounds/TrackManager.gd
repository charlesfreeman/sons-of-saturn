extends Control

var songs = []
var current_song = "None"

onready var tween_fo = $TweenFadeOut
onready var tween_fi = $TweenFadeIn

func _ready():
	tween_fo.connect("tween_completed", self, "reset_old_song")
	for song in self.get_children():
		songs.append(song.get_name())


func check_for_song(song: String):
	if song in songs:
		return true
	else:
		return false


func play(song: String):
	if song == current_song:
		pass
	elif check_for_song(song):
		print("checking for song: ", song)
		# fade out current song, fade in new one simultaneously
		if current_song != "None":
			print("transitioning")
			self.get_node(current_song).fade_out()
			self.get_node(song).fade_in()
			current_song = song
		# fade in new song (no old song playing)
		else:
			self.get_node(song).fade_in()
			current_song = song
	# fade out song (no new song)
	elif song == "None":
		print("No song")
		self.get_node(current_song).fade_out()
		current_song = song
	else:
		print("Warning, song not in tracks list: ", song)

