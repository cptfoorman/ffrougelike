extends Resource
class_name UnitAttack
@export var attack_name: String
@export var attackdmg: float
@export var attack_desc: String
@export var attack_anim_name:String
@export var attack_ofset: Vector2



func use_attack(target: Unit, strenght: int):
	var new_damage = attackdmg+strenght
	target.take_damage(new_damage)
