extends BuffData
class_name PoisonDeBuff

@export var damagePerTurn:int


func apply_end_turn_status(unit: Unit):
	unit.take_damage(damagePerTurn)
