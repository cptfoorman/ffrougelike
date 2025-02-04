extends UnitAttack
class_name UnitLifeStealAttack



func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	target.take_damage(new_damage)
	attacker.take_healing(attackdmg)
	set_on_cooldown()
	cooldown_attack()
