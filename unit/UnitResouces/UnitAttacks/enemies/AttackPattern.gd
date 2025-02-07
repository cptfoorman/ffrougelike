extends Resource
class_name AttackPattern


@export var pattern: Array[int]
var currentPatternIndex:= 0


func advancePattern():
	if currentPatternIndex >pattern.size()-1:
		currentPatternIndex = 0
	else:
		currentPatternIndex+=1
		
func get_current_pattern()->int:
	advancePattern()
	return currentPatternIndex
