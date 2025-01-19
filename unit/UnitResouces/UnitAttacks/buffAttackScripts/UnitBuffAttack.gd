extends UnitAttack
class_name UnitFriendlyBuffAttack


@export var buffData: BuffData

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	target.instance_friendly_buff(buffData)
	set_on_cooldown()
	cooldown_attack()
