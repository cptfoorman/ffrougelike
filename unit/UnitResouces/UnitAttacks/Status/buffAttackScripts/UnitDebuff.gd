extends UnitAttack
class_name UnitDeBuffAttack


@export var buffData: BuffData

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	target.take_damage(new_damage)
	target.instance_enemy_buff(buffData)
	set_on_cooldown()
	cooldown_attack()
