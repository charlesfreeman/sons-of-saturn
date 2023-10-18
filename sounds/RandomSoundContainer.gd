extends Node

var vols = []
var pitches = []
var soundlist = []
@export var volume_range : float
@export var pitch_range : float
@onready var rng = RandomNumberGenerator.new()


func _ready():
	for i in get_children():
		vols.append(i.volume_db)
		pitches.append(i.pitch_scale)
		soundlist.append(i)


func play(num=0, ran=true):
	self._get_ransnd().play()
	
	
func _get_ransnd():
	var chance = randi() % soundlist.size()
	var ransnd = soundlist[chance]
	_randomise_pitch_and_vol(ransnd)
	return ransnd
	
	
func _randomise_pitch_and_vol(sound):
	var vol = sound.get_parent().vols[sound.get_index()]
	var pitch = sound.get_parent().pitches[sound.get_index()]
	var newvol = (vol + rng.randf_range(-volume_range,volume_range))
	var newpitch = (pitch + rng.randf_range(-pitch_range,pitch_range))
	sound.volume_db = newvol
	sound.pitch_scale = newpitch
