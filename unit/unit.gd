extends Node2D
class_name Unit

var speed: int 
var health: float 
var mana: float 
var strenght: int
var inteligence: int
@export var row_position: int
enum MainAttackModifier {strenght, inteligence}
@export var attackModifier: MainAttackModifier


@export var animationFrames: SpriteFrames
@export var animations: AnimatedSprite2D
@export var flip_anim_h: bool 
@export var unitsstats: UnitStats
@export var unitattacks: Array[UnitAttack]
@export var unitdata: UnitData
var currentAttack: UnitAttack
@export var selectButton: Button
@onready var healthbar: ProgressBar = %health
@export var aoeanimScene: PackedScene


var enemyTarget: Unit
enum Faction {FRIENDLY, ENEMY}
@export var Factionset: Faction

signal SELECTED(unit: Unit)

func initialize() -> void:
	animations.sprite_frames = animationFrames
	animations.play("idle")
	unitsstats.currentUnit = self
	unitsstats.initialize()
	unitsstats.printstats()
	animations.flip_h = flip_anim_h
	prints("initializing", unitsstats.name, health)
	healthbar.max_value = health
	healthbar.value = health
	if Factionset == Faction.ENEMY:
		set_button_disabled()
	apply_unit_strategies()
	for attack in unitattacks:
		selectButton.tooltip_text += attack.attack_name + " 
		"
	unset_hover()



func apply_unit_strategies():
	for strategy in unitdata.unitStrategies:
		strategy.apply_strategy(self)
		print("unit "+ str(unitdata)+ " applying")

func get_main_attack_modifier()->int:
	match attackModifier:
		MainAttackModifier.strenght:
			return strenght
		MainAttackModifier.inteligence:
			return inteligence
	return 0
func set_as_enemy():
	Factionset = Faction.ENEMY
	
func set_as_friendly():
	Factionset = Faction.FRIENDLY
func get_attacks()-> Array[UnitAttack]:
	var units_attacks: Array[UnitAttack]
	for attack in unitattacks:
		if attack.attack_on_cooldown == false:
			units_attacks.append(attack)
	return units_attacks
func getName():
	return unitsstats.name
func take_damage(damage: float):
	var new_damage = damage
	new_damage-= unitsstats.defense
	if new_damage > 0:
		health -= new_damage
	prints(unitsstats.name, health)
	healthbar.value = health
	if health <= 0:
		queue_free()
		prints(unitsstats.name + " died")
		
func take_healing(healing: float):
	var new_healing = healing
	if new_healing > 0:
		health += new_healing
	prints(unitsstats.name, health)
	healthbar.value = health
	if health <= 0:
		queue_free()
		prints(unitsstats.name + " died")
func get_unit_data()->UnitData:
	return unitdata
	
func play_attack_anim(enemyposition: Vector2):
	var default_position = global_position
	var new_tween:= create_tween()
	new_tween.tween_property(self, "global_position",enemyposition + currentAttack.attack_ofset, 0.5)
	await new_tween.finished
	animations.play(currentAttack.attack_anim_name)
	await animations.animation_finished
	var new_tween2:= create_tween()
	animations.play("idle")
	new_tween2.tween_property(self, "global_position",default_position, 0.5)
func _on_select_button_pressed() -> void:
	SELECTED.emit(self)
	
func connect_attack_pressed(button: AttackButton):
	button.connect("AttackPressed", set_current_attack)
	
func set_current_attack(attack: UnitAttack):
	currentAttack = attack
	print(unitsstats.name +" is attacking with" + attack.attack_name)
func set_hover():
	selectButton.self_modulate = Color(197, 177, 136, 75)
func unset_hover():
	selectButton.self_modulate = Color(197, 177, 136, 0)
func _on_select_button_mouse_entered() -> void:
	set_hover()
func advance_attack_cooldowns():
	for attack in unitattacks:
		attack.cooldown_attack()
func set_button_disabled():
	selectButton.hide()
func set_button_enabled():
	selectButton.show()
func _on_select_button_mouse_exited() -> void:
	unset_hover()
func return_current_friendly_units()->Array[Unit]:
	var current_group_units: Array[Unit]
	for child in get_tree().get_first_node_in_group("FriendlyUnits").get_children():
		if child is Unit:
			current_group_units.append(child)
	return current_group_units
	
func return_current_enemy_units()->Array[Unit]:
	var current_group_units: Array[Unit]
	for child in get_tree().get_first_node_in_group("EnemyUnits").get_children():
		if child is Unit:
			current_group_units.append(child)
	return current_group_units
func spawn_aoe_sprite(spriteData: SpriteFrames, attackDamage: int):
	var new_anim: AoeAnim = aoeanimScene.instantiate()
	add_child(new_anim)
	new_anim.global_position = self.global_position
	new_anim.sprite_frames = spriteData
	new_anim.initialize()
	await new_anim.animation_finished
	take_damage(attackDamage)
