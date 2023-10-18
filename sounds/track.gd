extends AudioStreamPlayer

var old_db


func _ready():
	pass


func fade_out():
	old_db = self.volume_db
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.connect("finished", Callable(self, "reset_old_song"))
	tween.tween_property(self, "volume_db", -60, 1)
	
	
func fade_in():
	old_db = self.volume_db
	self.volume_db = -60
	self.playing = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "volume_db", old_db, 0.1)
	

func reset_old_song(_object, _key):
	self.stop()
	# immediately restore old volume after tween shift
	self.volume_db = old_db
