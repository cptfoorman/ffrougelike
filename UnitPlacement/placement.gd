extends Node2D
class_name UnitPlacer


signal PlacementStarted
signal PlacementFinished
signal UnitAdded(unit: Unit, unitPos: Vector2)
signal EnemyUnitAdded(unit: Unit, unitPos: Vector2)
@export var unitScene: PackedScene
@export var placementUI: PlacementUI
@export var unitHolder: UnitHolder
@export_group("friendly placement")
@export var row1: Node2D
@export var row2: Node2D
@export var row3: Node2D
@export var dropzonesrow1: Array[DropArea]
@export var dropzonesrow2: Array[DropArea]
@export var dropzonesrow3: Array[DropArea]
@export_group("enemy placement")
@export var availableEnemyUnitsArray: Array[UnitData]
@export var enemy_count: int = 3
@export var row4: Node2D
@export var row5: Node2D
@export var row6: Node2D
@export var markersRow4: Array[DropMarker]
@export var markersRow5: Array[DropMarker]
@export var markersRow6: Array[DropMarker]

##so this is the unit placer, its job is to instantiate units scenes, give them proper unit data and initialize them
## the rows and markers do violate DRY principles but its set up for the row mechanic
@onready var button: Button = %Button



func initialize(units: Array[UnitData], enemyCount: int, enemyUnitData: Array[UnitData] = []):
	enemy_count = enemyCount
	initializeUnitHolder(units)
	availableEnemyUnitsArray.resize(0)
	availableEnemyUnitsArray.append_array(enemyUnitData)
	for unit in availableEnemyUnitsArray:
		unit.set_local_to_scene(true)
func initializeUnitHolder(units: Array[UnitData]):
	unitHolder.initialize(units)

##########################################################################
##did the markers one by one for reasons above, rows would be important later
func fill_dropzone_arrays():
	print("found datazone")
	fill_dropzones1()
	fill_dropzones2()
	fill_dropzones3()
func fill_dropzones1():
	dropzonesrow1.resize(0)
	for child in row1.get_children():
		if child is DropArea:
			if child.unit_data != null:
				print("found data")
				dropzonesrow1.append(child)
func fill_dropzones2():
	dropzonesrow2.resize(0)
	for child in row2.get_children():
		if child is DropArea:
			if child.unit_data != null:
				dropzonesrow2.append(child)
func fill_dropzones3():
	dropzonesrow3.resize(0)
	for child in row3.get_children():
		if child is DropArea:
			if child.unit_data != null:
				dropzonesrow3.append(child)
func get_unit_data_from_dropzone(dropZone: DropArea)->UnitData:
	return dropZone.get_unit_data()
	
func fill_marker_arrays():
	get_markers_row4()
	get_markers_row5()
	get_markers_row6()

func get_markers_row4():
	markersRow4.resize(0)
	for child in row4.get_children():
		if child is DropMarker:
			markersRow4.append(child)
		
func get_markers_row5():
	markersRow5.resize(0)
	for child in row5.get_children():
		if child is DropMarker:
			markersRow5.append(child)
		
func get_markers_row6():
	markersRow6.resize(0)
	for child in row6.get_children():
		if child is DropMarker:
			markersRow6.append(child)
		

func get_marker(markerArray: Array[DropMarker])->DropMarker:
	var new_marker: DropMarker = markerArray.pick_random()
	markerArray.erase(new_marker)
	return new_marker
	
############################################################
###heres where instancing happens####################
##this is a placeholder of sorts for enemy instances
func fill_enemy_units():
	for i in enemy_count:
		var randomRow: Array[int] = [1,2,3]
		var random_num: int = randomRow.pick_random()
		match random_num:
			1:
				instantiate_enemy_unit(availableEnemyUnitsArray.pick_random(),get_marker(markersRow4).global_position, 1)
			2:
				instantiate_enemy_unit(availableEnemyUnitsArray.pick_random(),get_marker(markersRow5).global_position, 2)
			3:
				instantiate_enemy_unit(availableEnemyUnitsArray.pick_random(),get_marker(markersRow6).global_position, 3)

func fill_units():
	for dropzone in dropzonesrow1:
		
		instantiate_unit(get_unit_data_from_dropzone(dropzone), dropzone.global_position, 1)
	for dropzone in dropzonesrow2:
		instantiate_unit(get_unit_data_from_dropzone(dropzone), dropzone.global_position, 2)
	for dropzone in dropzonesrow3:
		instantiate_unit(get_unit_data_from_dropzone(dropzone), dropzone.global_position, 3)
	PlacementFinished.emit()
	unitHolder.clear_dragables()
	row1.hide()
	row2.hide()
	row3.hide()
	
###############################################################################
###these funcs instance just a blank unit which then gets data and initializes on signal#
func instantiate_enemy_unit(unit_data: UnitData, globalpos: Vector2, unitRow: int):
	var new_unit: Unit = unitScene.instantiate()
	new_unit.unitdata = unit_data.duplicate(true)
	new_unit.animationFrames = unit_data.get_spriteframes()
	new_unit.unitsstats = unit_data.get_unitstats()
	new_unit.unitattacks.append_array(unit_data.get_unitAttacks())
	new_unit.global_position = globalpos
	new_unit.row_position = unitRow
	new_unit.Factionset = new_unit.Faction.ENEMY
	add_child(new_unit)
	new_unit.unitdata.level = globalSceneLoader.current_enemy_lvlup
	new_unit.flip_anim_h = unit_data.anim_flip
	EnemyUnitAdded.emit(new_unit, globalpos)

func instantiate_unit(unit_data: UnitData, globalpos: Vector2, unitRow: int):
	var new_unit: Unit = unitScene.instantiate()
	new_unit.unitdata = unit_data
	new_unit.unitdata.set_local_to_scene(true)
	new_unit.animationFrames = unit_data.get_spriteframes()
	new_unit.unitsstats = unit_data.get_unitstats()
	var new_unit_attacks: Array[UnitAttack]
	for attack in unit_data.get_unitAttacks():
		new_unit_attacks.append(attack.duplicate())
	new_unit.unitattacks.append_array(new_unit_attacks)
	new_unit.global_position = globalpos
	new_unit.row_position = unitRow
	add_child(new_unit)
	new_unit.flip_anim_h = unit_data.anim_flip
	UnitAdded.emit(new_unit, globalpos)
	
	
	
	
func _on_button_pressed() -> void:
	button.set_deferred("disabled", true)
	fill_marker_arrays()
	await get_tree().create_timer(0.5).timeout
	fill_enemy_units()
	fill_dropzone_arrays()
	await get_tree().create_timer(0.5).timeout
	fill_units()
	placementUI.hide()
