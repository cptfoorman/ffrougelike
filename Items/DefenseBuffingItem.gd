extends DefenseItem
class_name DefenseBuffingItem


@export var defenseIncrease: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.defense += defenseIncrease
		unit.spawn_aoe_sprite(itemfxanims,0)
	
