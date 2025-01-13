extends Base_Unit_Strategy
class_name AddAttackStrategy

@export var new_attack: UnitAttack

func apply_strategy(unit: Unit):
	var new_attack_clone = new_attack.duplicate(true)
	unit.unitattacks.append(new_attack_clone)
	print("adding attack to "+unit.unitsstats.name)
