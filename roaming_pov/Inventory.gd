extends GridContainer

var num_items = 0

onready var inv_slots = [$Inv1, $Inv2, $Inv3]


func _ready():
	for i in range(len(Global.inventory)):
		inv_slots[i].set_item(Global.inventory[i])
		num_items += 1
		
func add_item(item):
	inv_slots[num_items].set_item(item)
	Global.add_to_inv(item)
	num_items += 1
