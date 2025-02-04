extends UnitSelfHealAttack
class_name UnitFriendlyAoEBuffAttack

@export var buff: BuffData

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	var targetArray: Array[Unit]
	targetArray.append_array(target.return_current_friendly_units())
	for unit in targetArray:
		unit.spawn_aoe_sprite_no_damage(buff.buffAnim)
		buff.apply_buff(unit)
	set_on_cooldown()
	cooldown_attack()
