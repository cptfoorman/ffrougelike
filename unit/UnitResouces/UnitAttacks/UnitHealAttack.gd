extends UnitAttack
class_name UnitHealAttack

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	attacker.take_healing(new_damage)
	set_on_cooldown()
	cooldown_attack()
