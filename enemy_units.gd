extends Node2D
class_name EnemyController

var possible_units_array: Array[Unit]
var possible_target_units: Array[Unit]

signal EnemyTurnOver
signal UnitsEmpty

func set_possible_target_units(unitArray: Array[Unit]):
	possible_target_units.resize(0)
	possible_target_units.append_array(unitArray)





func set_active_units(unitArray: Array[Unit]):
	possible_units_array.resize(0)
	possible_units_array.append_array(unitArray)
func get_by_row_unit(attack: UnitAttack)-> Unit:
	var best_row: int = attack.attack_reach
	var mainRowUnits: Array[Unit]
	var otherRowUnits: Array[Unit]
	var row_unit: Unit
	for unit in possible_target_units:
		if best_row >= unit.row_position:
			mainRowUnits.append(unit)
		else:
			otherRowUnits.append(unit)
	if mainRowUnits.is_empty():
		row_unit = otherRowUnits.pick_random()
	else:
		row_unit = mainRowUnits.pick_random()
	return row_unit

func get_random_unit()-> Unit:
	var random_unit: Unit = possible_units_array.pick_random()
	return random_unit
func get_random_opponent_unit()->Unit:
	var random_unit: Unit = possible_target_units.pick_random()
	return random_unit
	
func get_random_unit_attack(unit: Unit)->UnitAttack:
	var attack: UnitAttack = unit.unitattacks.pick_random()
	return attack
	
func enemy_attack():
	if possible_units_array.is_empty() == false:
		var attacker: Unit = get_random_unit()
		var attack: UnitAttack = get_random_unit_attack(attacker)
		var defender: Unit = get_by_row_unit(attack)
		attacker.currentAttack = attack
		attacker.play_attack_anim(defender.global_position)
		await attacker.animations.animation_finished
		attacker.currentAttack.use_attack(defender, attacker.get_main_attack_modifier(), attacker)
		await get_tree().create_timer(0.7).timeout
		EnemyTurnOver.emit()
	else:
		UnitsEmpty.emit()
		print("units empty")
