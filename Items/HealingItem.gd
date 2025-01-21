extends DefenseItem
class_name HealingItem


@export var healingPower: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.take_healing(healingPower)
		unit.spawn_aoe_sprite(itemfxanims, 0)
	
