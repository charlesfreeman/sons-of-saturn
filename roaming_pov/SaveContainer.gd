extends VBoxContainer

const load_button = preload("res://roaming_pov/load.tscn")

var load_button_names = []

signal stage_savegame(new_savegame)
signal stage_deletion(sg_to_delete)


# Called when the node enters the scene tree for the first time.
func _ready():
	self._sort_filenames()
	for button_name in load_button_names:
		var new_load_button = load_button.instantiate()
		new_load_button.set_savegame(button_name)
		self.add_child(new_load_button)
		new_load_button.connect("stage_savegame", Callable(self, "_stage_savegame"))
		new_load_button.connect("stage_deletion", Callable(self, "_stage_deletion"))


func _on_save_new_save_button():
	self._sort_filenames()
	var new_load_button = load_button.instantiate()
	new_load_button.set_savegame(load_button_names[0])
	self.add_child(new_load_button)
	self.move_child(new_load_button, 2)
	
	
func _sort_filenames():
	var dir = DirAccess.open("user://")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.begins_with("sos"):
				load_button_names.append(file_name)
			file_name = dir.get_next()
	load_button_names.sort_custom(func(a,b): return _get_timestamp(a) > _get_timestamp(b))
	
	
func _get_timestamp(a: String):
	var arr = a.split("_")
	return arr[-3] + arr[-2] + arr[-1]
	
	
func _stage_savegame(new_savegame):
	emit_signal("stage_savegame", new_savegame)
	
	
func _stage_deletion(sg_to_delete):
	emit_signal("stage_deletion", sg_to_delete)
	
	
