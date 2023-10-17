extends AudioStreamPlayer

var old_db

@onready var tween = create_tween()


func _ready():
	tween.connect("tween_completed", Callable(self, "reset_old_song"))


func fade_out():
	old_db = self.volume_db
	tween.tween_property(self, "volume_db", -60, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	
func fade_in():
	old_db = self.volume_db
	self.volume_db = -60
	self.playing = true
	tween.tween_property(self, "volume_db", old_db, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	

func reset_old_song(_object, _key):
	self.stop()
	# immediately restore old volume after tween shift
	self.volume_db = old_db
