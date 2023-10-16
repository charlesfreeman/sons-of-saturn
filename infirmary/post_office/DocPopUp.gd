extends Area2D

var in_clickable_area = false
var doc_visible = false
var index = 0

@onready var doc = $Document

@export var my_collision_polygon_node_path: NodePath


func _ready():
	add_child(get_node(my_collision_polygon_node_path).duplicate())
	doc.hide()


func _on_FullRect_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		# if clicking outside activation area or already displayed, hide the document
		# otherwise, made it visible
		if not self.in_clickable_area or doc_visible:
			doc.hide()
			doc_visible = false
		else:
			doc.show()
			doc_visible = true


func _on_OnClickPopUp_mouse_entered():
	print("entered clickable area")
	self.in_clickable_area = true


func _on_OnClickPopUp_mouse_exited():
	print("exited clickable area")
	self.in_clickable_area = false
