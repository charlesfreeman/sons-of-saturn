extends VBoxContainer

# Example script to demonstrate how to use twison helper.
# Please attach this script to RichTextLabel with bbcodes enabled.
# Then, attach meta_clicked(...) signal to _on_meta_clicked(...) function.
# This script expects the helper script to be located at
# res://modules/twison-godot/twison_helper.gd

const spokenLine = preload("res://dialogue_system/SpokenLine.tscn")
const spokenLineNochar = preload("res://dialogue_system/SpokenLineNoChar.tscn")

onready var twison = preload("res://modules/twison-godot/twison_helper.gd")
onready var Twison = twison.new()
onready var scroll_container = $ScrollContainer
onready var spoken_lines_container = $ScrollContainer/SpokenLinesContainer
onready var tween = $Tween
onready var scroll_bar = scroll_container.get_v_scrollbar()
var dialogueOption = load("res://dialogue_system/DialogueOption.tscn")
var continueButton = load("res://dialogue_system/ContinueButton.tscn")

export(String, FILE, "*.json") var scriptPath = "res://dialogue_system/conversations/test_scene.json"

var max_scroll_length = 0
var passage_index = 0
var paragraph_array
var buttons_array
var link_names
var stack = []
# for keeping track of current character speaking
var current_char: String = "None"
var continue_button

signal change_char(character)

func _ready():
	print("initializing")
	Twison.parse_file(scriptPath)

	self.buttons_array = get_tree().get_nodes_in_group("buttons")
	
	scroll_bar.connect("changed", self, "handle_scrollbar_changed")
	scroll_bar.modulate = Color(0, 0, 0, 0)
	
	var starting_node = Twison.get_starting_node()
	# Show first passage in our RichTextLabel 
	self._load_next_block(starting_node)
	
	
func handle_scrollbar_changed():
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		_scroll_to_end()
	
	
func _scroll_to_end():
	tween.interpolate_property(scroll_container, "scroll_vertical", scroll_container.scroll_vertical, max_scroll_length, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	
	
# handles setting up next twison passage and corresponding links
func _load_next_block(name):
	self._remove_buttons()
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
	
	# mechanism to not repeat same text when returning from short loop
	if not next_chapter in self.stack or len(self.link_names) == 1:
		print("name not in stack")
		self.stack.append(next_chapter)

		# extract text from the chapter and split based on newlines
		var np_text = next_chapter["text"]
		self.paragraph_array = _split_block(np_text)
		
		var num_paragraphs = self.paragraph_array.size()
		self._load_paragraph(self.paragraph_array[0])
		if num_paragraphs == 1:
			print("adding buttons")
			self._add_buttons()
		else:
			print("instancing continue button")
			self.continue_button = continueButton.instance()
			add_child(self.continue_button)
			self.continue_button.connect("pressed", self, "_on_ContinueButton_pressed")
			self.continue_button.grab_focus()
	# if chapter is in stack and multiple buttons, skip straight to displaying
	# all the buttons.  Rationale is that player doesn't need to see the same
	# preceding block of text over and over when returning to a dialogue node
	# with branching options
	else:
		print("name in stack")
		self._add_buttons()


# convenience function for splitting block into an array of paragraphs, with
# newlines interpreted as delimiters.  Returns array of paragraphs
func _split_block(block):
	var parray = block.split("\n")
	# convoluted way of removing the null entries
	var indices_to_cut = []
	for i in range(parray.size()):
		if parray[i] == "":
			indices_to_cut.append(i)
	indices_to_cut.invert()
	for index in indices_to_cut:
		parray.remove(index)
	return parray


# instance spoken_line or spoken_line_nochar, set text and/or char, and add as 
# child to the spoken_lines_container
func _load_paragraph(paragraph):
	var para_array
	var char_name
	var text
	if "::" in paragraph:
		var spoken_line = spokenLine.instance()
		para_array = paragraph.split("::")
		char_name = para_array[0]
		text = "\"" + para_array[1] + "\""
		spoken_line.set_speaker_name(char_name)
		spoken_line.set_dialogue_line(text)
		spoken_lines_container.add_child(spoken_line)
		if char_name != current_char:
			current_char = char_name
			emit_signal("change_char", current_char)
	else:
		var spoken_line = spokenLineNochar.instance()
		spoken_line.set_text(paragraph)
		spoken_lines_container.add_child(spoken_line)


func _add_buttons():
	for i in range(len(self.link_names)):
		print("adding button ", i)
		var dialogue_opt = dialogueOption.instance()
		add_child(dialogue_opt)
		dialogue_opt.connect("pressed", self, "_pressed", [i])
		self.buttons_array.append(dialogue_opt)
		var button_text = self.link_names[i]
		dialogue_opt.extract_text_and_modifiers(button_text)
		if i == 0:
			# TODO might need to release focus first but I'm not sure
			dialogue_opt.grab_focus()
	# after adding buttons the ScrollContainer is sometimes resized, so we need
	# to make sure the scrollbar is set to the very end
	_scroll_to_end()


func _remove_buttons():
	for i in range(len(buttons_array)-1, -1, -1):
		print("removing ", i)
		self.buttons_array[i].queue_free()
		self.buttons_array.remove(i)


func _pressed(index: int):
	print("button pressed", index)
	var button = buttons_array[index]
	# only need to echo input back to scrollContainer if not in continue mode
	if not button.continue_mode:
		var you_text = "You::" + button.get_text()
		self._load_paragraph(you_text)
	
#	var t = Timer.new()
#	t.set_wait_time(0.5)
#	t.set_one_shot(true)
#	self.add_child(t)
#	t.start()
#	yield(t, "timeout")
#	t.queue_free()
		
	self._load_next_block(button.get_next_passage())
	
	
func _on_ContinueButton_pressed():
	self.passage_index += 1
	self._load_paragraph(self.paragraph_array[self.passage_index])
	if self.passage_index == self.paragraph_array.size()-1:
		self.passage_index = 0
		self.continue_button.queue_free()
		self._add_buttons()
