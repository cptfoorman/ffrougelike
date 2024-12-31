extends Resource
class_name UnitData


@export var spriteFrames: SpriteFrames
@export var unitStats: UnitStats
@export var unitAttacks: Array[UnitAttack]
@export var anim_flip: bool

func get_spriteframes()->SpriteFrames:
	return spriteFrames
	
func get_unitstats()->UnitStats:
	return unitStats
func get_unitAttacks()->Array[UnitAttack]:
	return unitAttacks
