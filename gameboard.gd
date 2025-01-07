extends Node2D
class_name Gameboard

@export var friendlyUnitsGroup: Node2D
@export var enemyUnitsGroup: EnemyController
@export var current_friendly_unit: Unit
@export var current_enemy_unit: Unit
@export var mainUI: UI

func initialize(units: Array[UnitData]):
	var unitPlacer: UnitPlacer = get_tree().get_first_node_in_group("UnitPlacer")
	unitPlacer.initialize(units)

func initialize_unit_signals() -> void:
	connect_friendly_unit_signal()
	connect_enemy_unit_signals()
	
func connect_friendly_unit_signal():
	for child in friendlyUnitsGroup.get_children():
		child.connect("SELECTED", _on_unit_selected)
func connect_enemy_unit_signals():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.connect("SELECTED", _on_enemy_unit_selected)
func set_enemy_buttons_enabled():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_enabled()
func set_enemy_buttons_disabled():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_disabled()
func set_friendly_buttons_enabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_enabled()
func set_friendly_buttons_disabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_disabled()
func _on_unit_selected(unit: Unit) -> void:
	current_friendly_unit = unit
	print("i selected "+ current_friendly_unit.getName())
	mainUI.initialize_attack_ui(unit)
func get_current_enemy_units()->Array[Unit]:
	var new_unit_array: Array[Unit]
	for child in enemyUnitsGroup.get_children():
		new_unit_array.append(child)
	return new_unit_array
func get_current_friendly_units()->Array[Unit]:
	var new_unit_array: Array[Unit]
	for child in friendlyUnitsGroup.get_children():
		new_unit_array.append(child)
	return new_unit_array
func set_enemy_turn():
	mainUI.set_enemy_turn()
	set_friendly_buttons_disabled()
	enemyUnitsGroup.set_active_units(get_current_enemy_units())
	enemyUnitsGroup.set_possible_target_units(get_current_friendly_units())
	enemyUnitsGroup.enemy_attack()
func set_friendly_turn():
	print("friendly TURN")
	mainUI.set_friendly_turn()
	set_friendly_buttons_enabled()
	set_enemy_buttons_disabled()
	var new_unit_array:= get_current_friendly_units()
	if new_unit_array.is_empty() == true:
		globalSceneLoader.instantiate_start_screen()
	else:
		print(new_unit_array)
func initialize_enemy_units():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.initialize()
func _on_enemy_unit_selected(enemyUnit: Unit):
	mainUI.reset_ui_anim()
	set_enemy_buttons_disabled()
	current_friendly_unit.play_attack_anim(enemyUnit.global_position)
	current_friendly_unit.currentAttack.use_attack(enemyUnit, current_friendly_unit.get_main_attack_modifier())
	await current_friendly_unit.animations.animation_finished
	set_enemy_turn()
func _on_ui_attack_selected() -> void:
	print("looking to kill")
	set_enemy_buttons_enabled()


func _on_ui_attack_deselected() -> void:
	print("peacefull life")
	set_enemy_buttons_disabled()


func _on_enemy_units_enemy_turn_over() -> void:
	set_friendly_turn()



func _on_placement_placement_finished() -> void:
	initialize_enemy_units()
	initialize_unit_signals()
	set_enemy_buttons_disabled()
	


func _on_placement_unit_added(unit: Unit, unitPos: Vector2) -> void:
	unit.reparent(friendlyUnitsGroup)
	unit.position = unitPos
	unit.initialize()


func _on_placement_enemy_unit_added(unit: Unit, unitPos: Vector2) -> void:
	unit.reparent(enemyUnitsGroup)
	unit.position = unitPos
	unit.initialize()


func _on_enemy_units_units_empty() -> void:
	var survivor_units: Array[UnitData]
	for unit in get_current_friendly_units():
		survivor_units.append(unit.get_unit_data())
	globalSceneLoader.instantiate_upgrader(survivor_units)
