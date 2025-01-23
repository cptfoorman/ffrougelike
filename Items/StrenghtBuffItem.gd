extends DefenseItem
class_name StrenghtBuffItem


@export var strenghtIncrease: int


func use_item(targets: Array[Unit]):
	for unit in targets:
		unit.strenght += strenghtIncrease
	
