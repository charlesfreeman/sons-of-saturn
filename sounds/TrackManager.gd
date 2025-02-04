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
		var track = get_node(song)
		if track.independent:
			# NOTE might want to change this to fade_in
			# if just a one-off, just play the song and don't update the state
			# of the current song
			if not track.playing:
				track.play()
			else:
				track.fade_out()
		elif current_song != "None":
			self.get_node(current_song).fade_out()
			track.fade_in()
			current_song = song
		# fade in new song (no old song playing)
		else:
			track.fade_in()
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


func definitely_play(song):
	if not get_node(song).playing:
		get_node(song).play()
