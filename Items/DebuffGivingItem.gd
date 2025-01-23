extends AttackItem
class_name DebuffGivingItem


@export var debuff: BuffData

func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.instance_enemy_buff(debuff)
		unit.spawn_aoe_sprite(itemfxanims, 0)
	
