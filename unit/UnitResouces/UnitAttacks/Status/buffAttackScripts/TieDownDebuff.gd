extends BuffData
class_name TieDownDeBuff



func apply_buff(unit: Unit):
	unit.isTiedDown = true
	
func deapply_buff(unit: Unit, stats: int):
	unit.isTiedDown = false
