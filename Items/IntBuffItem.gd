extends DefenseItem
class_name IntBuffItem


@export var intIncrease: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.inteligence += intIncrease
		unit.spawn_aoe_sprite_no_damage(itemfxanims)
	
