extends UnitAttack
class_name AoEDebuffAttack

@export var aoeanimFrames: SpriteFrames
@export var deBuff: BuffData

func use_attack(target: Unit, strenght: int, attacker: Unit):
	var new_damage = attackdmg+strenght
	var targetArray: Array[Unit]
	targetArray.append_array(target.return_current_enemy_units())
	for unit in targetArray:
		unit.spawn_aoe_sprite(aoeanimFrames, new_damage)
		deBuff.apply_buff(unit)
	set_on_cooldown()
	cooldown_attack()
	
