extends Control

const spokenLine = preload("res://dialogue_system/SpokenLine.tscn")
const spokenLineNochar = preload("res://dialogue_system/SpokenLineNoChar.tscn")
const spokenLineNarrator = preload("res://dialogue_system/SpokenLineNarrator.tscn")
const continue_text = "C->"

@onready var twison = preload("res://modules/twison-godot/twison_helper.gd")
@onready var Twison = twison.new()
@onready var button_container = $VBoxContainer/ButtonContainer
@onready var scroll_container = $VBoxContainer/ScrollContainer
@onready var spoken_lines_container = $VBoxContainer/ScrollContainer/SpokenLinesContainer
@onready var scroll_bar = scroll_container.get_v_scroll_bar()
@onready var typewriter = $VBoxContainer/TypewriterSounds
var dialogueOption = load("res://dialogue_system/DialogueOption.tscn")
var continueButton = load("res://dialogue_system/ContinueButton.tscn")
var script_path = "res://dialogue_system/conversations/test_scene.json"
var next_scene = "roaming_pov"
var max_scroll_length = 0
var passage_index = 0
var paragraph_array
var buttons_array
var link_names
var stack = []
var links_clicked = []
# for keeping track of current character speaking
var current_char: String = "None"
var continue_button
# might need to refactor to array if ever want to add more than one party mem
# following a convo
var new_party_mem = ""
var mem_to_remove = ""
var next_location = ""
var prog_flag = "None"
# for tracking if current_char or emotion state has changed
var state_changed = false

# multiple aliases used for same character in some cases
# need this dict to compress them
var char_aliases = {
	"Amelie" : "Amelie",
	"You" : "Amelie",
	"Wiggly" : "Wiggly",
	"Ferryman" : "Wiggly",
	"Julia" : "Julia",
	"Frail Woman" : "Julia",
	"Jasper" : "Jasper",
	"Malformed Lump" : "Jasper",
	"Voice" : "Jasper",
	"Tann" : "Tann",
	"Ansel" : "Ansel",
	"Vera" : "Vera",
	"Robert" : "Robert",
	"Leslie" : "Leslie",
	"Note" : "Note",
	"Dead Cat" : "Dead Cat",
	"Narrator" : "Narrator",
}

# for tracking the state of the char emotions
var emotions = {
	"Amelie" : "neutral",
	"Wiggly" : "neutral",
	"Jasper" : "neutral", 
	"Julia" : "neutral",
	"Tann" : "Tann",
	"Ansel" : "Ansel",
	"Vera" : "Vera",
	"Robert" : "Robert",
	"Leslie" : "Leslie",
	"Note" : "None",
	"Dead Cat" : "Dead Cat",
	"Narrator" : "None",
}

signal change_char(character, emotion)
signal tag(tags)


func init():
	Twison.parse_file(script_path)

	self.buttons_array = get_tree().get_nodes_in_group("buttons")
	
	scroll_bar.connect("changed", Callable(self, "handle_scrollbar_changed"))
	scroll_bar.modulate = Color(0, 0, 0, 0)
	
	var starting_node = Twison.get_starting_node()
	# Show first passage in our RichTextLabel 
	self._load_next_block(starting_node)
	
	
func handle_scrollbar_changed():
	if max_scroll_length != scroll_bar.max_value:
		max_scroll_length = scroll_bar.max_value
		_scroll_to_end()
	
	
func _scroll_to_end():
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(scroll_container, "scroll_vertical", max_scroll_length, 0.3)
	
	
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
	
	var tags = twison.get_passage_tags(next_chapter)
	if len(tags) > 0:
		emit_signal("tag", tags)
	
	# get the links from the chapter
	self.link_names = Twison.get_passage_links(next_chapter)
	
	# mechanism to not repeat same text when returning from short loop
	if not next_chapter in self.stack or len(self.link_names) == 1:
		self.stack.append(next_chapter)

		# extract text from the chapter and split based on newlines
		var np_text = next_chapter["text"]
		
		# if no text in block, finish convo and load next scene
		if np_text == "":
			_load_next_scene()
			return

		self.paragraph_array = _split_block(np_text)
		
		var num_paragraphs = self.paragraph_array.size()
		
		# don't do anything if paragraph only exists for tag emission
		if np_text != "TAG":
			self._load_paragraph(self.paragraph_array[0])
		
		if num_paragraphs == 1:
			if len(self.link_names) == 0:
				self._add_continue_button("_load_next_scene")
			elif len(self.link_names) == 1:
				self._add_buttons()
			else:
				self._add_continue_button("_final_continue")
		else:
			self._add_continue_button("_on_ContinueButton_pressed")
	# if chapter is in stack and multiple buttons, skip straight to displaying
	# all the buttons.  Rationale is that player doesn't need to see the same
	# preceding block of text over and over when returning to a dialogue node
	# with branching options
	else:
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
	indices_to_cut.reverse()
	for index in indices_to_cut:
		parray.remove_at(index)
	return parray


# instance spoken_line or spoken_line_nochar, set text and/or char, and add as 
# child to the spoken_lines_container
func _load_paragraph(paragraph):
	var para_array
	var char_name_array
	var char_name
	var text
	var emotion = "None"
	if "::" in paragraph:
		para_array = paragraph.split("::")
		char_name = para_array[0]
		text = para_array[1]
		
		# extract emotion and emit signal for face swap
		if "," in char_name:
			char_name_array = char_name.split(",")
			char_name = char_name_array[0]
			emotion = char_name_array[1]
		
	else:
		char_name = "Narrator"
		text = paragraph

	text.trim_suffix("\n")
		
	# dim all previous lines
	get_tree().call_group("SpokenLines", "make_grey")
	
	if current_char != char_name:
		current_char = char_name
		# if Amelie the current char, then the state of the current_char isn't really changing,
		# because the updates to the avatar have already been made by the tag system.
		if current_char != "You":
			state_changed = true
		if char_name == "Narrator":
			var linebreak = spokenLineNochar.instantiate()
			linebreak.set_text("  ------- ------- ------- ------- ------- ")
			spoken_lines_container.add_child(linebreak)
			
			var spoken_line = spokenLineNarrator.instantiate()
			spoken_line.set_text(text)
			spoken_lines_container.add_child(spoken_line)
		else:
			var spoken_line = spokenLine.instantiate()
			
			spoken_line.set_speaker_name(char_name)
			spoken_line.set_dialogue_line(text)
			spoken_lines_container.add_child(spoken_line)
	else:
		if current_char == "Narrator":
			var spoken_line = spokenLineNarrator.instantiate()
			spoken_line.set_text(text)
			spoken_lines_container.add_child(spoken_line)
		else:
			var spoken_line = spokenLineNochar.instantiate()
			spoken_line.set_text(text)
			spoken_lines_container.add_child(spoken_line)
			
	if emotion != emotions[char_aliases[current_char]] and emotion != "None":
		emotions[char_aliases[current_char]] = emotion
		state_changed = true
		
	# emit signal if state of char or emotion updated, then reset variable
	if state_changed:
		emit_signal("change_char", char_aliases[current_char], emotions[char_aliases[current_char]])
		state_changed = false


func _add_buttons():
	# Amelie char texture loaded upon buttons being added
	if len(self.link_names) > 1:
		emit_signal("change_char", "Amelie", "neutral")

	for i in range(len(self.link_names)):
		var button_text = self.link_names[i]
		var display_button = true
		# TODO consider using a different symbol as this prevents the use of semicolons in text
		if ";" in button_text:
			# TODO I think this only allows for requiring one clicked passage?
			var required_passage_index = int(button_text[0])
			display_button = _check_if_clicked(required_passage_index)
			if "->" in button_text:
				var text_array = button_text.split("->")
				display_button = display_button or text_array[1] in self.links_clicked
		if display_button:
			var dialogue_opt = dialogueOption.instantiate()
			button_container.add_child(dialogue_opt)
			dialogue_opt.connect("pressed", Callable(self, "_pressed").bind(i))
			# TODO consider if buttons_array at all necessary
			self.buttons_array.append(dialogue_opt)
			if button_text in self.links_clicked:
				dialogue_opt.set_as_clicked()
			dialogue_opt.extract_text_and_modifiers(button_text)
			dialogue_opt.set_opt_number(i+1)
			# NOTE: Possible issue here where if the first option isn't 
			# visible, no button will grab focus.  Twine conventions such that 
			# this shouldn't ever occur but it's something to remember
			if i == 0:
				# TODO might need to release focus first but I'm not sure
				dialogue_opt.grab_focus()
	# after adding buttons the ScrollContainer is sometimes resized, so we need
	# to make sure the scrollbar is set to the very end
	_scroll_to_end()


func _add_continue_button(method_to_connect: String):
	var dialogue_opt = dialogueOption.instantiate()
	button_container.add_child(dialogue_opt)
	dialogue_opt.connect("pressed", Callable(self, method_to_connect))
	self.buttons_array.append(dialogue_opt)
	dialogue_opt.extract_text_and_modifiers(continue_text)
	dialogue_opt.set_opt_number(0)
	dialogue_opt.grab_focus()


func _remove_buttons():
	for i in range(len(buttons_array)-1, -1, -1):
		self.buttons_array[i].queue_free()
		self.buttons_array.remove_at(i)


# check if n'th dialogue option in list has been clicked before
func _check_if_clicked(index: int) -> bool:
	if self.link_names[index] in self.links_clicked:
		return true
	else:
		return false


func _pressed(index: int):
	typewriter.play()
	var button = buttons_array[index]
	# only need to echo input back to scrollContainer if not in continue mode
	# don't want to add continue presses to scroll memory
	if not button.continue_mode:
		var you_text = "You::" + button.get_text()
		self._load_paragraph(you_text)
		if not _check_if_clicked(index):
			self.links_clicked.append(self.link_names[index])

	self._load_next_block(button.get_next_passage())
	
	
func _on_ContinueButton_pressed():
	typewriter.play()
	self.passage_index += 1
	self._load_paragraph(self.paragraph_array[self.passage_index])
	if self.passage_index == self.paragraph_array.size()-1:
		self.passage_index = 0
		# if no links, instance continue and connect to load next scene
		if len(self.link_names) == 0:
			buttons_array[0].disconnect("pressed", Callable(self, "_on_ContinueButton_pressed"))
			buttons_array[0].connect("pressed", Callable(self, "_load_next_scene"))
		elif len(self.link_names) == 1:
			buttons_array[0].queue_free()
			self.buttons_array.remove_at(0)
			self._add_buttons()
		else: 
			if self.link_names[0].begins_with("C->") or self.link_names[0].begins_with("Continue->"):
				buttons_array[0].disconnect("pressed", Callable(self, "_on_ContinueButton_pressed"))
				buttons_array[0].connect("pressed", Callable(self, "_pressed").bind(0))
			else:
				buttons_array[0].disconnect("pressed", Callable(self, "_on_ContinueButton_pressed"))
				buttons_array[0].connect("pressed", Callable(self, "_final_continue"))


func _final_continue():
	typewriter.play()
	buttons_array[0].queue_free()
	self.buttons_array.remove_at(0)
	self._add_buttons()


# for programatically setting the dialogue path when instancing
func set_script_path(path):
	script_path = path
	

func set_next_scene_path(path):
	next_scene = path
	
	
func set_mem_to_add(mem):
	new_party_mem = mem


func set_mem_to_remove(mem):
	mem_to_remove = mem
	
	
func set_next_location(new_loc):
	next_location = new_loc
	

func set_prog_flag(new_prog_flag):
	prog_flag = new_prog_flag


func _load_next_scene():
	Global.add_to_party(new_party_mem)
	Global.remove_from_party(mem_to_remove)
	Global.set_location(next_location)
	if prog_flag != "None":
		Global.flip_prog_flag(prog_flag)
	var options = SceneManager.create_options()
	var general_options = SceneManager.create_general_options()
	SceneManager.change_scene(next_scene, options, options, general_options)






