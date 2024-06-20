extends Control

@export var label_text = ""

signal yes_pressed
signal no_pressed


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label_text



func _on_yes_button_pressed():
	emit_signal("yes_pressed")


func _on_no_button_pressed():
	emit_signal("no_pressed")
