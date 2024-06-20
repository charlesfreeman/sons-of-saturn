extends Control

var savegame = ""
var savegame_to_delete = ""

@onready var saves = $Saves
@onready var exit_button = $ExitButton
@onready var load_game_option = $LoadGameOption
@onready var delete_game_option = $DeleteGameOption


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_save_container_stage_savegame(new_savegame):
	get_tree().call_group("saveload_button", "disable")
	savegame = new_savegame
	saves.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
	exit_button.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
	load_game_option.visible = true


func _on_loadgame_yes_button_pressed():
	Global.load_game(savegame)


func _on_loadgame_no_button_pressed():
	load_game_option.visible = false
	self.enable_savegames()


func _on_save_container_stage_deletion(sg_to_delete):
	get_tree().call_group("saveload_button", "disable")
	savegame_to_delete = sg_to_delete
	saves.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
	exit_button.modulate = Color(Global.dbrightness, Global.dbrightness, Global.dbrightness, 1)
	delete_game_option.visible = true


func _on_delete_yes_button_pressed():
	get_tree().call_group("load_button", "check_if_deleted", savegame_to_delete)
	Global.delete_save(savegame_to_delete)
	delete_game_option.visible = false
	self.enable_savegames()


func _on_delete_no_button_pressed():
	delete_game_option.visible = false
	self.enable_savegames()


func enable_savegames():
	saves.modulate = Color(1, 1, 1, 1)
	exit_button.modulate = Color(1, 1, 1, 1)
	get_tree().call_group("saveload_button", "enable")
