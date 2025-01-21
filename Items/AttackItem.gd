extends Item
class_name AttackItem


@export var damage: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.spawn_aoe_sprite(itemfxanims, damage)
	
