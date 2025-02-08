extends Node2D
class_name Gameboard

@export var friendlyUnitsGroup: Node2D
@export var enemyUnitsGroup: EnemyController
@export var current_friendly_unit: Unit
@export var current_enemy_unit: Unit
@export var itemBackpack: ItemBackpack
@export var mainUI: UI
var unitPlacer: UnitPlacer
@onready var playercam: Camera2D = %playercam

func initialize(units: Array[UnitData], unitcount: int, enemyUnitData: Array[UnitData], items: Array[Item]):
	unitPlacer = get_tree().get_first_node_in_group("UnitPlacer")
	unitPlacer.initialize(units, unitcount, enemyUnitData)
	itemBackpack.initialize(items)

func initialize_unit_signals() -> void:
	connect_friendly_unit_signal()
	connect_enemy_unit_signals()
	
func connect_friendly_unit_signal():
	for child in friendlyUnitsGroup.get_children():
		child.connect("SELECTED", _on_unit_selected)
		child.connect("FRIENDLYSELECTED", _on_friendly_select)
func connect_enemy_unit_signals():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.connect("SELECTED", _on_enemy_unit_selected)
func set_enemy_buttons_enabled(attack_row: int):
	var child_count: int = 0
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			if child.row_position <= attack_row:
				child.set_button_enabled()
				child_count +=1
	if child_count == 0:
		set_all_enemy_buttons_enabled()
func set_all_enemy_buttons_enabled():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_enabled()
func set_enemy_buttons_disabled():
	for child in enemyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_disabled()
			child.set_friendly_select_disabled()
func set_friendly_buttons_enabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_enabled()
func set_friendly_buttons_disabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_button_disabled()
func set_select_friendly_buttons_enabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_friendly_select_enabled()
func set_select_friendly_buttons_disabled():
	for child in friendlyUnitsGroup.get_children():
		if child is Unit:
			child.set_friendly_select_disabled()
func _on_unit_selected(unit: Unit) -> void:
	current_friendly_unit = unit
	print("i selected "+ current_friendly_unit.getName())
	mainUI.initialize_attack_ui(unit, itemBackpack.get_current_items())
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
	for unit in get_current_friendly_units():
		unit.advance_attack_cooldowns()
	mainUI.set_enemy_turn()
	set_friendly_buttons_disabled()
	set_select_friendly_buttons_disabled()
	enemyUnitsGroup.set_active_units(get_current_enemy_units())
	enemyUnitsGroup.set_possible_target_units(get_current_friendly_units())
	enemyUnitsGroup.enemy_attack()
func set_friendly_turn():
	for unit in get_current_enemy_units():
		unit.advance_attack_cooldowns()
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
	tween_camera_in(enemyUnit)
	await current_friendly_unit.animations.animation_finished
	current_friendly_unit.currentAttack.use_attack(enemyUnit, current_friendly_unit.get_main_attack_modifier(), current_friendly_unit)
	tween_camera_out()
	await get_tree().create_timer(1.2).timeout
	set_enemy_turn()
func _on_ui_attack_selected(unitattack: UnitAttack) -> void:
	print("looking to kill")
	if unitattack is UnitSelfHealAttack:
		_on_friendly_select(current_friendly_unit)
		await get_tree().create_timer(0.2).timeout
		mainUI.reset_ui_anim()
	elif unitattack is UnitFriendlyBuffAttack:
		set_friendly_buttons_disabled()
		set_select_friendly_buttons_enabled()
	else:
		set_enemy_buttons_enabled(unitattack.attack_reach)
func tween_camera_in(defender: Unit):
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(playercam,"zoom", Vector2(2,2), 0.5 )
	tween.tween_property(playercam, "global_position", defender.global_position, 0.5 )

func tween_camera_out():
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(playercam,"zoom", Vector2(1.295,1.295), 0.5 )
	tween.tween_property(playercam, "global_position", Vector2(354,198), 0.5 )

func _on_ui_attack_deselected() -> void:
	print("peacefull life")
	set_enemy_buttons_disabled()
	set_select_friendly_buttons_disabled()
	set_friendly_buttons_enabled()


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
	globalSceneLoader.current_money += (20*globalSceneLoader.currentdiff)
	mainUI.initialize_rewards(globalSceneLoader.clone_random_unit())
	


func _on_ui_added_to_party(newPartyUnit: UnitData) -> void:
	var survivor_units: Array[UnitData]
	for unit in get_current_friendly_units():
		if unit.Factionset == unit.Faction.FRIENDLY:
			survivor_units.append(unit.get_unit_data())
	survivor_units.append(newPartyUnit)
	globalSceneLoader.set_current_party_array(survivor_units)
	await get_tree().create_timer(0.5).timeout
	globalSceneLoader.instantiate_path_tree()

func _on_ui_upgrades_selected() -> void:
	var survivor_units: Array[UnitData]
	for unit in get_current_friendly_units():
		if unit.Factionset == unit.Faction.FRIENDLY:
			survivor_units.append(unit.get_unit_data())
	await get_tree().create_timer(0.3).timeout
	for unit in survivor_units:
		unit.gain_level()
	globalSceneLoader.instantiate_path_tree()
	globalSceneLoader.lvlUpMultiplier = 0
func _on_friendly_select(friendlyUnit: Unit):
	mainUI.reset_ui_anim()
	set_enemy_buttons_disabled()
	set_friendly_buttons_disabled()
	set_select_friendly_buttons_disabled()
	current_friendly_unit.play_attack_anim(friendlyUnit.global_position)
	await current_friendly_unit.animations.animation_finished
	current_friendly_unit.currentAttack.use_attack(friendlyUnit, current_friendly_unit.get_main_attack_modifier(), current_friendly_unit)
	await get_tree().create_timer(1.2).timeout
	set_enemy_turn()


func _on_ui_item_selected(item: Item) -> void:
	mainUI.reset_ui_anim()
	set_enemy_buttons_disabled()
	set_friendly_buttons_disabled()
	set_select_friendly_buttons_disabled()
	itemBackpack.instantiate_item_use(item)
	await get_tree().create_timer(0.3).timeout
	if item is DefenseItem:
		item.use_item(get_current_friendly_units())
	elif item is AttackItem:
		item.use_item(get_current_enemy_units())
	itemBackpack.remove_item(item)
	await get_tree().create_timer(1.2).timeout
	set_enemy_turn()


func _on_ui_turn_passed() -> void:
	mainUI.reset_ui_anim()
	set_enemy_buttons_disabled()
	set_friendly_buttons_disabled()
	set_select_friendly_buttons_disabled()
	await get_tree().create_timer(1.2).timeout
	set_enemy_turn()
