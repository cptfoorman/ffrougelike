extends Resource
class_name UnitData


@export var spriteFrames: SpriteFrames
@export var level: int
@export var unitStats: UnitStats
@export var unitAttacks: Array[UnitAttack]
@export var anim_flip: bool
@export var unitStrategies: Array[Base_Unit_Strategy]
@export var levelUpUnitStrategies: Array[Base_Unit_Strategy]
@export var collisionForDragable: PackedScene
@export var craftable_item: Item

func get_spriteframes()->SpriteFrames:
	return spriteFrames
	
func get_unitstats()->UnitStats:
	return unitStats
func get_unitAttacks()->Array[UnitAttack]:
	return unitAttacks
func _setup_local_to_scene():
	set_local_to_scene(true)
func add_strategy(strategy:Base_Unit_Strategy):
	unitStrategies.append(strategy)
	print("got strategy")
	
func add_unitAttack(unitAttack:Array[UnitAttack]):
	unitAttacks.append(unitAttack)
func gain_level():
	level += clampi(1+globalSceneLoader.lvlUpMultiplier,1, levelUpUnitStrategies.size()-1)
