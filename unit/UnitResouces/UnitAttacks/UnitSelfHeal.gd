extends UnitAttack
class_name UnitSelfHealAttack

@export var healAnim: SpriteFrames

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	attacker.spawn_aoe_sprite_no_damage(healAnim)
	attacker.take_healing(new_damage)
	set_on_cooldown()
	cooldown_attack()
