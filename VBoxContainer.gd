extends VBoxContainer

# Example script to demonstrate how to use twison helper.
# Please attach this script to RichTextLabel with bbcodes enabled.
# Then, attach meta_clicked(...) signal to _on_meta_clicked(...) function.
# This script expects the helper script to be located at
# res://modules/twison-godot/twison_helper.gd

onready var twison = preload("res://modules/twison-godot/twison_helper.gd")
onready var Twison = twison.new()
export(String, FILE, "*.json") var scriptPath = "res://data.json"

var max_num_buttons = 3
var num_buttons_to_show = 0
var num_buttons_displayed = 0
var buttons_array
var link_names

func _ready():
	# Initialize the script
	#Twison.parse_file(scriptPath, funcref(Twison, "link_filter_bbcode"))
	Twison.parse_file(scriptPath)

	self.buttons_array = get_tree().get_nodes_in_group("buttons")
	var starting_node = Twison.get_passage(Twison.get_starting_node())
	self.link_names = Twison.get_passage_link_names(starting_node)
	# Print some info about the story
	print("Story name: ", Twison.get_story_name())
	
	self._display_buttons()
	
	print("There are also following tags: ")
	for tag in Twison.get_all_tags():
		print(tag)
		tag = Twison.get_passages_tagged_with(tag)
		print("Passages marked with this tag (pids): ", tag)
	self._display_buttons()
	# Show first passage in our RichTextLabel 
	$RichTextLabel.add_text(Twison.get_passage(Twison.get_starting_node())["text"])
	
	$Button1.grab_focus()


func _load_next_block(name):
	var next_chapter = Twison.get_passage_by_name(name)
	self.link_names = Twison.get_passage_link_names(next_chapter)
	$RichTextLabel.newline()
	$RichTextLabel.newline()
	$RichTextLabel.add_text("[indent]"+next_chapter["text"]+"[/indent]")
	self._display_buttons()
	$Button1.release_focus()
	$Button1.grab_focus()


func _display_buttons():
	self.num_buttons_to_show = len(self.link_names)
	if self.num_buttons_to_show < self.num_buttons_displayed:
		for i in range(self.num_buttons_to_show, self.max_num_buttons):
			self.buttons_array[i].hide()
	elif self.num_buttons_to_show > self.num_buttons_displayed:
		for i in range(self.num_buttons_displayed, self.num_buttons_to_show):
			self.buttons_array[i].show()
	for i in range(self.num_buttons_to_show):
		self.buttons_array[i].set_text(self.link_names[i])
	self.num_buttons_displayed = self.num_buttons_to_show


func _on_meta_clicked(meta):
	print("\nLink clicked: ", meta)
	var next_chapter = Twison.get_passage_by_name(meta)
	
	if (next_chapter.has("links")):
		print("Next passage has following links:")
		for i in Twison.get_passage_links(next_chapter):
			print("\t"+i)
	
	#show_passage(next_chapter)


func _on_Button1_pressed():
	self._load_next_block($Button1/RichTextLabel.text)


func _on_Button2_pressed():
	self._load_next_block($Button2/RichTextLabel.text)


func _on_Button3_pressed():
	self._load_next_block($Button3/RichTextLabel.text)


func _on_Button1_focus_entered():
	print("button 1 focus entered")
	self.buttons_array[0].highlight_text()


func _on_Button1_focus_exited():
	print("focus exited")
	self.buttons_array[0].dehighlight_text()


func _on_Button2_focus_entered():
	print("button 2 focus entered")
	self.buttons_array[1].highlight_text()


func _on_Button2_focus_exited():
	print("focus 2 exited")
	self.buttons_array[1].dehighlight_text()


func _on_Button3_focus_entered():
	print("button 3 focus entered")
	self.buttons_array[2].highlight_text()


func _on_Button3_focus_exited():
	print("focus 3 exited")
	self.buttons_array[2].dehighlight_text()


func _on_Button1_mouse_entered():
	self.buttons_array[0].grab_focus()


func _on_Button2_mouse_entered():
	self.buttons_array[1].grab_focus()
	

func _on_Button3_mouse_entered():
	self.buttons_array[2].grab_focus()
