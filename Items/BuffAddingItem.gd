extends DefenseItem
class_name BuffGivingItem


@export var buff: BuffData


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.instance_friendly_buff(buff)
		unit.spawn_aoe_sprite_no_damage(itemfxanims)
	
