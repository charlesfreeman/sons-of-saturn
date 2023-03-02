extends GridContainer

onready var inv_slots = [$Inv1, $Inv2, $Inv3]


func _ready():
	for i in range(len(Global.inventory)):
		inv_slots[i].set_item(Global.inventory[i])
