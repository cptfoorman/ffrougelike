extends Resource
class_name UnitStats

@export_group("unit stats")
@export var name: String
@export var speed: int = 10
@export var health: float = 10
@export var mana: float = 20
@export var strenght: int = 5
@export var inteligence: int = 5
@export var defense: float

var currentUnit: Unit

@export var main_modifier: int

func initialize() -> void:
	currentUnit.health = health
	currentUnit.speed = speed
	currentUnit.inteligence = inteligence
	currentUnit.mana = mana
	currentUnit.strenght = strenght
	currentUnit.attackModifier = main_modifier
	
func printstats():
	prints(name, speed , health, mana, strenght, inteligence)
