extends Area2D


export(NodePath) var my_collision_polygon_node_path


func _ready():
	add_child(get_node(my_collision_polygon_node_path).duplicate())
