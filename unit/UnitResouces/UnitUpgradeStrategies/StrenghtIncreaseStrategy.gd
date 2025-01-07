extends Base_Unit_Strategy
class_name StrenghtIncreaseStrategy

@export var additional_strenght: int

func apply_strategy(unit: Unit):
	unit.strenght += additional_strenght
	
