extends Base_Unit_Strategy
class_name IntIncreaseStrategy

@export var additional_int: int

func apply_strategy(unit: Unit):
	unit.inteligence += additional_int
	
