extends Area2D

var char_path_dict = {
	"Rando": "res://images/gas_mask_cropped_no_marquee.png"
}

onready var popup = $PopUp

export var popup_image_char = "Rando"
export var popup_text = "example text for popup"


func _ready():
	popup.hide()
	popup.set_popup_image_path(char_path_dict[popup_image_char])
	popup.set_popup_text(popup_text)


func hide_popup():
	popup.hide()


func _on_OnClickPopUp_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		popup.show()
