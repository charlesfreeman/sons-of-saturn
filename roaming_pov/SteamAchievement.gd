extends Control

const ach_icon_paths = {
	"BASEMENT_SURGICAL_POSTER" : "res://roaming_pov/images/achievement_icons/basement_poster_256.jpg",
	"WIGGLY_ANNOYED" : "res://roaming_pov/images/achievement_icons/wiggly_annoyed_256x256.jpg",
	"FROG" : "res://roaming_pov/images/achievement_icons/frog_zoomed_in_256x256.jpg",
	"EMPTY_ROOM_POSTER" : "res://roaming_pov/images/achievement_icons/empty_room_poster_256x256.jpg",
	"COMPUTER" : "res://roaming_pov/images/achievement_icons/computer_256x256.jpg",
	"COURTYARD" : "res://roaming_pov/images/achievement_icons/courtyard_256x256.jpg",
	"CRIB" : "res://roaming_pov/images/achievement_icons/crib_256x256.jpg",
}

@onready var ach_title_label = $HBoxContainer/VBoxContainer/Title
@onready var ach_desc_label = $HBoxContainer/VBoxContainer/Desc
@onready var icon = $HBoxContainer/Icon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_title(title: String):
	ach_title_label.text = title


func set_desc(desc: String):
	ach_desc_label.text = desc
	
	
func set_icon(name: String):
	icon.texture = load(ach_icon_paths[name])


func load_ach_display(ach_name: String):
	var title = Steam.getAchievementDisplayAttribute(ach_name, "name")
	var desc = Steam.getAchievementDisplayAttribute(ach_name, "desc")
	self.set_title(title)
	self.set_desc(desc)
	self.set_icon(ach_name)

	await get_tree().create_timer(0.5).timeout
	var tween_fadein = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_fadein.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15).finished
	await get_tree().create_timer(3.0).timeout
	var tween_fadeout = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween_fadeout.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.15).finished
