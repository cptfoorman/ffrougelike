extends BuffData
class_name StrenghtBuff


@export var strenghtIncrease: int

func apply_buff(unit: Unit):
	unit.strenght += strenghtIncrease
	
func deapply_buff(unit: Unit, stats: int):
	unit.strenght -= strenghtIncrease
