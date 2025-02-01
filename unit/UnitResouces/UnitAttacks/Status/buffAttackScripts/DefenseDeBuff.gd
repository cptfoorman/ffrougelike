extends BuffData
class_name DefenseDeBuff


@export var defenseDeBuff:int


func apply_buff(unit: Unit):
	unit.defense -= defenseDeBuff
