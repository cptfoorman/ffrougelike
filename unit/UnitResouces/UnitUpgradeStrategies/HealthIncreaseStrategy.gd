extends Base_Unit_Strategy
class_name HealthIncreaseStrategy

@export var additional_health: int

func apply_strategy(unit: Unit):
	unit.health += additional_health
	
