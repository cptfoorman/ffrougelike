extends UnitAttack
class_name AoEAttack

@export var aoeanimFrames: SpriteFrames


func use_attack(target: Unit, strenght: int):
	var new_damage = attackdmg+strenght
	var targetArray: Array[Unit]
	targetArray.append_array(target.return_current_enemy_units())
	for unit in targetArray:
		unit.take_damage(new_damage)
		unit.spawn_aoe_sprite(aoeanimFrames)
	set_on_cooldown()
	cooldown_attack()
	
