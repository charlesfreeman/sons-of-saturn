extends VBoxContainer

# Example script to demonstrate how to use twison helper.
# Please attach this script to RichTextLabel with bbcodes enabled.
# Then, attach meta_clicked(...) signal to _on_meta_clicked(...) function.
# This script expects the helper script to be located at
# res://modules/twison-godot/twison_helper.gd

onready var twison = preload("res://modules/twison-godot/twison_helper.gd")
onready var Twison = twison.new()
export(String, FILE, "*.json") var scriptPath = "res://dialogue_system/conversations/test_scene.json"

var max_num_buttons = 3
var num_buttons_displayed = 0
var buttons_array
var link_names
var passage_index = 0
var paragraph_array

func _ready():
	# Initialize the script
	#Twison.parse_file(scriptPath, funcref(Twison, "link_filter_bbcode"))
	Twison.parse_file(scriptPath)

	self.buttons_array = get_tree().get_nodes_in_group("buttons")
	$ContinueButton.hide()
	var starting_node = Twison.get_starting_node()
	# Print some info about the story
	print("Story name: ", Twison.get_story_name())
	print("Starting node: ", starting_node)
	# Show first passage in our RichTextLabel 
	self._load_next_block(starting_node)


func _load_next_block(name):
	print("next_chapter: ", name)
	var next_chapter
	if typeof(name) == TYPE_STRING:
		next_chapter = Twison.get_passage_by_name(name)
	elif typeof(name) == TYPE_INT:
		next_chapter = Twison.get_passage(name)
	else:
		assert(false, "Passage identifier name neither a string nor an int")
		
	self.link_names = Twison.get_passage_link_names(next_chapter)
	$RichTextLabel.newline()
	$RichTextLabel.newline()
	var np_text = next_chapter["text"]
	self.paragraph_array = np_text.split("\n")
	var indices_to_cut = []
	for i in range(self.paragraph_array.size()):
		if self.paragraph_array[i] == "":
			indices_to_cut.append(i)
	indices_to_cut.invert()
	for index in indices_to_cut:
		self.paragraph_array.remove(index)
	var num_paragraphs = self.paragraph_array.size()
	# $RichTextLabel.append_bbcode("[indent]"+self.paragraph_array[0]+"[/indent]")
	self._load_paragraph(self.paragraph_array[0])
	if num_paragraphs == 1:
		self._display_buttons()
		$Button1.release_focus()
		$Button1.grab_focus()
	else:
		$ContinueButton.show()


func _load_paragraph(paragraph):
		if ":" in paragraph:
			var para_array = paragraph.split(":")
			var char_name = para_array[0]
			var text = para_array[1]
			var line_length = 80
			$RichTextLabel.append_bbcode("\n[color=aqua]"+char_name+"[/color]")
			if text.length() < line_length:
				$RichTextLabel.append_bbcode("\n[indent]"+text+"[/indent]")
			else:
				var index = line_length
				while index < text.length():
					while text[index] != " ":
						index -= 1
					index += 1
					text = text.insert(index, "\n")
					index += 1
					print("index:")
					print(text[index])
					index += 1
					index += line_length
				$RichTextLabel.append_bbcode("\n[indent]"+text+"[/indent]")
			print("hi there"[2] == " ")
		else:
			$RichTextLabel.append_bbcode("\n[indent]"+paragraph+"[/indent]")
	


func _display_buttons():
	# if this is being called we can hide the continue button
	$ContinueButton.hide()
	
	var num_buttons_to_show = len(self.link_names)
	if num_buttons_to_show < self.num_buttons_displayed:
		for i in range(num_buttons_to_show, self.max_num_buttons):
			self.buttons_array[i].hide()
	elif num_buttons_to_show > self.num_buttons_displayed:
		for i in range(self.num_buttons_displayed, num_buttons_to_show):
			self.buttons_array[i].show()
	for i in range(num_buttons_to_show):
		self.buttons_array[i].set_text(self.link_names[i])
	self.num_buttons_displayed = num_buttons_to_show


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


func _on_ContinueButton_pressed():
	self.passage_index += 1
	# $RichTextLabel.append_bbcode(self.paragraph_array[self.passage_index])
	self._load_paragraph(self.paragraph_array[self.passage_index])
	if self.passage_index == self.paragraph_array.size():
		self._display_buttons()
	
