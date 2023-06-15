extends AudioStreamPlayer

var old_db

onready var tween_fo = $TweenFO
onready var tween_fi = $TweenFI


func _ready():
	tween_fo.connect("tween_completed", self, "reset_old_song")


func fade_out():
	old_db = self.volume_db
	tween_fo.interpolate_property(self, "volume_db", self.volume_db, -60, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	tween_fo.start()
	
	
func fade_in():
	old_db = self.volume_db
	self.volume_db = -60
	self.playing = true
	tween_fi.interpolate_property(self, "volume_db", self.volume_db, old_db, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween_fi.start()
	

func reset_old_song(_object, _key):
	self.stop()
	# immediately restore old volume after tween shift
	self.volume_db = old_db
	print("fo completed")
