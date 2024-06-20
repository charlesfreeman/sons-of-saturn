extends Node

var steam_app_id: int = 2493140


func _ready() -> void:
	initialize_steam()


func _process(_delta: float) -> void:
	Steam.run_callbacks()


func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx(false, steam_app_id)
	print("Did Steam initialize?: %s" % initialize_response)
