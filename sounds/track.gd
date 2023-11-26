extends AudioStreamPlayer

var old_db
var tweening = false

@export var independent = false

@onready var base_volume = self.volume_db


func _ready():
	self.reduce_volume()


func fade_out():
	self.tweening = true
	old_db = self.volume_db
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.tween_property(self, "volume_db", -60, 1).finished
	self.reset_old_song()
	self.tweening = false
	
	
func fade_in():
	self.tweening = true
	old_db = self.volume_db
	self.volume_db = -60
	self.playing = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await tween.tween_property(self, "volume_db", old_db, 0.3).finished
	self.tweening = false
	

func reset_old_song():
	self.stop()
	# immediately restore old volume after tween shift
	self.volume_db = old_db


# expect sound_effect_vol to be some value between -50 and 0, determined by player
# functionality here limited for simplicity, changes made while tweening simply
# have no effect.  This isn't optimal but is unlikely to matter much.
func reduce_volume():
	if not self.tweening:
		self.volume_db = base_volume + Global.sound_track_vol
	
