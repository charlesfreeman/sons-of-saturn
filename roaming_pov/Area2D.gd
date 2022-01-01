extends Area2D

onready var popup = $PopUp

export(String, FILE) var popup_image_path
export var popup_text = "example text for popup"


func _ready():
	popup.hide()
	popup.set_popup_image_path(popup_image_path)
	popup.set_popup_text(popup_text)


func hide_popup():
	popup.hide()


func _on_OnClickPopUp_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		popup.show()
