extends Node2D
class_name PartyBuilder


@export var availableUnitsArray: Array[UnitData]

@export var partyUnitsArray: Array[UnitData]
@export var unitHolder: UnitHolder
@export var clonedUnitsArray: Array[UnitData]
@onready var go_button: Button = %GoButton

signal UnitsReady(units: Array[UnitData])

func initialize(units: Array[UnitData]):
	availableUnitsArray = units
	unitHolder.initialize(units)
	await get_tree().create_timer(0.5).timeout
	connect_dragables()

func initializeUnitHolder(units: Array[UnitData]):
	unitHolder.initialize(units)

func get_party_units()->Array[UnitData]:
	return partyUnitsArray
func clone_party_units(units:Array[UnitData]):
	clonedUnitsArray.resize(0)
	for unit in get_party_units():
		var cloned_unit = unit.duplicate()
		clonedUnitsArray.append(cloned_unit)
		
func get_cloned_party_units()->Array[UnitData]:
	return clonedUnitsArray
		
		
func _process(delta: float) -> void:
	if partyUnitsArray.is_empty():
		go_button.hide()
	else:
		go_button.show()
func connect_dragables():
	for child in unitHolder.get_children():
		if child is Dragable:
			child.label.hide()
			child.connect("TakenAway", _on_dragable_taken_away)
			child.connect("Dropped", _on_dragable_dropped)
func _on_dragable_dropped(unit_data: UnitData) -> void:
	partyUnitsArray.append(unit_data)


func _on_dragable_taken_away(unit_data: UnitData) -> void:
	for data in partyUnitsArray:
		if data.get_unitstats().name == unit_data.get_unitstats().name:
			partyUnitsArray.erase(data)
			break


func _on_go_button_pressed() -> void:
	print("button")
	UnitsReady.emit(get_party_units())
