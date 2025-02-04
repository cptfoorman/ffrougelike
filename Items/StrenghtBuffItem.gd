extends DefenseItem
class_name StrenghtBuffItem


@export var strenghtIncrease: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.strenght += strenghtIncrease
		unit.spawn_aoe_sprite_no_damage(itemfxanims)
	
