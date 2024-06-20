extends Node2D

@onready var logo = $TextureRect/Logo
@onready var developed = $TextureRect/Developed
@onready var soundtrack = $TextureRect/Soundtrack
@onready var collage = $TextureRect/Collage
@onready var Amelie = $TextureRect/Amelie
@onready var Wiggly = $TextureRect/Wiggly
@onready var Julia = $TextureRect/Julia


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.change_song("None")
	await get_tree().create_timer(2.0).timeout
	logo.visible = true
	await get_tree().create_timer(4.0).timeout
	logo.visible = false
	await get_tree().create_timer(1.0).timeout
	developed.visible = true
	await get_tree().create_timer(2.0).timeout
	developed.visible = false
	await get_tree().create_timer(1.0).timeout
	soundtrack.visible = true
	await get_tree().create_timer(2.0).timeout
	soundtrack.visible = false
	await get_tree().create_timer(1.0).timeout
	collage.visible = true
	await get_tree().create_timer(2.0).timeout
	collage.visible = false
	await get_tree().create_timer(1.0).timeout
	Amelie.visible = true
	await get_tree().create_timer(2.0).timeout
	Amelie.visible = false
	await get_tree().create_timer(1.0).timeout
	Wiggly.visible = true
	await get_tree().create_timer(2.0).timeout
	Wiggly.visible = false
	await get_tree().create_timer(1.0).timeout
	Julia.visible = true
	await get_tree().create_timer(2.0).timeout
	Julia.visible = false
	await get_tree().create_timer(1.0).timeout
	Global.change_song("breathing_machine_softer")
	Global.location = "res://wiggly_sad_place/tunnel_entrance/tunnel_entrance.tscn"
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene("roaming_pov", options, options, general_options)

