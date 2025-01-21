extends BuffData
class_name DefenseBuff


@export var defenseIncrease: int

func apply_buff(unit: Unit):
	unit.defense += defenseIncrease
	
func deapply_buff(unit: Unit, stats: int):
	unit.defense -= defenseIncrease
