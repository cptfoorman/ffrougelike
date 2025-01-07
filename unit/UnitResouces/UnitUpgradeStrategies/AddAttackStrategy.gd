extends Base_Unit_Strategy
class_name AddAttackStrategy

@export var new_attack: UnitAttack

func apply_strategy(unit: Unit):
	unit.unitattacks.append(new_attack)
	print("adding attack to "+unit.unitsstats.name)
