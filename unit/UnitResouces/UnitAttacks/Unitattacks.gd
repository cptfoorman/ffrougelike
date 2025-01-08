extends Resource
class_name UnitAttack
@export var attack_name: String
@export var attackdmg: float
@export var attack_desc: String
@export var attack_anim_name:String
@export var attack_ofset: Vector2
@export var attack_max_cooldown: int
@export var attack_on_cooldown: bool
var attack_cooldown: int

func use_attack(target: Unit, strenght: int):
	var new_damage = attackdmg+strenght
	target.take_damage(new_damage)
	set_on_cooldown()
	cooldown_attack()
	
func set_on_cooldown():
	if attack_on_cooldown == false:
		attack_cooldown = attack_max_cooldown
		attack_on_cooldown = true
func cooldown_attack():
	attack_cooldown -= 1
	if attack_cooldown <=0:
		attack_on_cooldown = false
	
