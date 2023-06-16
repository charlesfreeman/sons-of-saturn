extends Control

var songs = []
var current_song = "None"


func _ready():
	for c in self.get_children():
		songs.append(c.get_name())


func check_for_song(song: String):
	if song in songs:
		return true
	else:
		return false


func play(song: String):
	if song == current_song:
		pass
	elif check_for_song(song):
		if current_song != "None":
			self.get_node(current_song).fade_out()
			self.get_node(song).fade_in()
			current_song = song
		# fade in new song (no old song playing)
		else:
			self.get_node(song).fade_in()
			current_song = song
	# fade out song (no new song)
	elif song == "None":
		self.get_node(current_song).fade_out()
		current_song = song
	else:
		print("Warning, song not in tracks list: ", song)


func stop():
	self.get_node(current_song).fade_out()
	current_song = "None"
