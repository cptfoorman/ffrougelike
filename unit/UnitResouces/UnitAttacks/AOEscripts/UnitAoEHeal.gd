extends UnitAttack
class_name AoEHeal

@export var anims: SpriteFrames


func use_attack(target: Unit, strenght: int,attacker: Unit):
	var new_damage = attackdmg+strenght
	var targetArray: Array[Unit]
	targetArray.append_array(target.return_current_friendly_units())
	for unit in targetArray:
		unit.take_healing(new_damage)
		unit.spawn_aoe_sprite(anims, 0)
	set_on_cooldown()
	cooldown_attack()
	
