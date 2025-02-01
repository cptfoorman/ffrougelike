extends UnitSelfHealAttack
class_name UnitSelfBuffAttack

@export var buff: BuffData

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	attacker.spawn_aoe_sprite_no_damage(buff.buffAnim)
	buff.apply_buff(attacker)
	set_on_cooldown()
	cooldown_attack()
