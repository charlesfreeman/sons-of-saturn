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
var stack = []

# dict for associating character names with colors for dialogue box
var char_colors = {"Wigley": "aqua", "You": "red", "Georgia": "blue"}
# for keeping track of current character speaking
var current_char: String = "None"

signal change_char(character)

func _ready():
	Twison.parse_file(scriptPath)

	self.buttons_array = get_tree().get_nodes_in_group("buttons")
	$ContinueButton.hide()
	var starting_node = Twison.get_starting_node()
	# Show first passage in our RichTextLabel 
	self._load_next_block(starting_node)


# handles setting up next twison passage and corresponding links
func _load_next_block(name):
	# extract the next chapter using the identifier
	var next_chapter
	if typeof(name) == TYPE_STRING:
		next_chapter = Twison.get_passage_by_name(name)
	elif typeof(name) == TYPE_INT:
		next_chapter = Twison.get_passage(name)
	else:
		assert(false, "Passage identifier name neither a string nor an int")
		
	# get the links from the chapter
	self.link_names = Twison.get_passage_links(next_chapter)
	print("link names: ", self.link_names)
	
	# mechanism to not repeat same text when returning from short loop
	# hacky as hell but so is everything else
	if not next_chapter in self.stack or len(self.link_names) == 1:
		print("name not in stack")
		self.stack.append(next_chapter)

		# extract text from the chapter and split based on newlines
		var np_text = next_chapter["text"]
		self.paragraph_array = np_text.split("\n")
		# convoluted way of removing the null entries
		var indices_to_cut = []
		for i in range(self.paragraph_array.size()):
			if self.paragraph_array[i] == "":
				indices_to_cut.append(i)
		indices_to_cut.invert()
		for index in indices_to_cut:
			self.paragraph_array.remove(index)
		var num_paragraphs = self.paragraph_array.size()
		self._load_paragraph(self.paragraph_array[0])
		if num_paragraphs == 1:
			self._display_buttons()
			$Option1.release_focus()
			$Option1.grab_focus()
		else:
			self._hide_buttons()
			$ContinueButton.load_block_mode = false
			$ContinueButton.show()
			$ContinueButton.grab_focus()
			
	else:
		self._display_buttons()
		$Option1.release_focus()
		$Option1.grab_focus()
		


func _load_paragraph(paragraph):
	var para_array
	var char_name
	var text
	if ":" in paragraph:
		para_array = paragraph.split(":")
		char_name = para_array[0]
		text = para_array[1]
		if char_name != self.current_char:
			emit_signal("change_char", char_name)
			self.current_char = char_name
			var char_color = self.char_colors[char_name]
			$RichTextLabel.append_bbcode("\n[color=%s]"%char_color+char_name+"[/color]")
	else:
		text = paragraph
	# likely need to adjust this once dims settled
	var line_length = 80
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
			index += 1
			index += line_length
		$RichTextLabel.append_bbcode("\n[indent]"+text+"[/indent]")
	$RichTextLabel.newline()


func _display_buttons():
	var num_buttons_to_show = len(self.link_names)
	
	if num_buttons_to_show == 1:
		# if only one link want continue button to take over
		# hide other buttons, set to load_block_mode, call set_next_passage
		self._hide_buttons()
		$ContinueButton.load_block_mode = true
		var button_text = self.link_names[0]
		if "->" in button_text:
			print("splitting link")
			var button_text_array = button_text.split("->")
			$ContinueButton.set_next_passage(button_text_array[1])
		else:
			$ContinueButton.set_next_passage(button_text)
		$ContinueButton.show()
	else:
		$ContinueButton.hide()
		
		# make the correct number of buttons visible
		if num_buttons_to_show < self.num_buttons_displayed:
			for i in range(num_buttons_to_show, self.max_num_buttons):
				self.buttons_array[i].hide()
		elif num_buttons_to_show > self.num_buttons_displayed:
			for i in range(self.num_buttons_displayed, num_buttons_to_show):
				self.buttons_array[i].show()
				
		for i in range(num_buttons_to_show):
			print("link names: ", self.link_names[i])
			var button_text = self.link_names[i]
			self.buttons_array[i].extract_text_and_modifiers(button_text)

		self.num_buttons_displayed = num_buttons_to_show


# specialty function needed in a few circumstances
func _hide_buttons():
	for i in range(self.max_num_buttons):
		self.buttons_array[i].hide()
		self.num_buttons_displayed = 0


func _on_Option1_pressed():
	var you_text = "You:" + $Option1.get_text()
	self._load_paragraph(you_text)
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
		
	self._load_next_block($Option1.get_next_passage())
	
	
func _on_Option2_pressed():
	var you_text = "You:" + $Option2.get_text()
	self._load_paragraph(you_text)
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	self._load_next_block($Option2.get_next_passage())
	
	
func _on_Option3_pressed():
	var you_text = "You:" + $Option3.get_text()
	self._load_paragraph(you_text)
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	self._load_next_block($Option3.get_next_passage())
	$RichTextLabel.append_bbcode("\n[indent]"+$Option3.get_text()+"[/indent]")


func _on_ContinueButton_pressed():
	# for connecting between twine cells with only one option
	if $ContinueButton.load_block_mode:
		self._load_next_block($ContinueButton.get_next_passage())
	# for in between paragraphs separated by newlines
	# does the labor of indexing through number of paragraphs in the cell, 
	# and loads the buttons when it's time for the player to speak
	else:
		self.passage_index += 1
		if self.passage_index == self.paragraph_array.size():
			self.passage_index = 0
			self._display_buttons()
		else:
			self._load_paragraph(self.paragraph_array[self.passage_index])
	
	


