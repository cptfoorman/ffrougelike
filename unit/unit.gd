extends Node2D
class_name Unit

var speed: int 
var health: float 
var mana: float 
var strenght: int
var inteligence: int
var defense: int
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
@export var friendlySelectButton: Button
@onready var health_value_label: Label = $health/healthValueLabel
@onready var healthbar: ProgressBar = %health
@onready var friendly_buff_holder: Node2D = %friendlyBuffHolder
@onready var enemy_buff_holder: Node2D = %EnemyBuffHolder



@export var aoeanimScene: PackedScene
@export var buffScene: PackedScene
var isTiedDown: bool = false
var enemyTarget: Unit
enum Faction {FRIENDLY, ENEMY, SUMMONED}
@export var Factionset: Faction

signal SELECTED(unit: Unit)
signal DAMAGED(damage: int)
signal FRIENDLYSELECTED(unit: Unit)
func initialize() -> void:
	animations.sprite_frames = animationFrames
	animations.play("idle")
	unitsstats.currentUnit = self
	unitsstats.initialize()
	unitsstats.printstats()
	defense = unitsstats.defense
	animations.flip_h = flip_anim_h
	prints("initializing", unitsstats.name, health)
	healthbar.max_value = health
	healthbar.value = health
	health_value_label.text = str(healthbar.value) + "HP"
	if Factionset == Faction.ENEMY:
		set_button_disabled()
	apply_unit_strategies()
	apply_level_up_strategies()
	selectButton.tooltip_text = "defense " +str(defense)
	unset_hover()

func apply_level_up_strategies():
	for i in unitdata.level:
		unitdata.levelUpUnitStrategies[i].apply_strategy(self)

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
func set_as_summoned():
	Factionset = Faction.SUMMONED
func set_as_friendly():
	Factionset = Faction.FRIENDLY
func get_attacks()-> Array[UnitAttack]:
	var units_attacks: Array[UnitAttack]
	for attack in unitattacks:
		if attack.attack_on_cooldown == false:
			units_attacks.append(attack)
	return units_attacks
	
func get_all_attacks()-> Array[UnitAttack]:
	return unitattacks
func getName():
	return unitsstats.name
func take_damage(damage: float):
	var new_damage = damage
	new_damage-= defense
	DAMAGED.emit(new_damage)
	if new_damage > 0:
		health -= new_damage
	prints(unitsstats.name, health)
	healthbar.value = health
	health_value_label.text = str(healthbar.value) + "HP"
	if health <= 0:
		queue_free()
		prints(unitsstats.name + " died")
		
func take_healing(healing: float):
	var new_healing = healing
	if new_healing > 0:
		health += new_healing
	prints(unitsstats.name, health)
	healthbar.value = health
	health_value_label.text = str(healthbar.value) + "HP"
	selectButton.tooltip_text = "defense " +str(defense)
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
	for buff in friendly_buff_holder.get_children():
		if buff is BuffHolder:
			buff.reduce_duration()
	for buff in enemy_buff_holder.get_children():
		if buff is BuffHolder:
			buff.reduce_duration()
func instance_friendly_buff(buff: BuffData):
	var new_buff: BuffHolder = buffScene.instantiate()
	friendly_buff_holder.add_child(new_buff)
	new_buff.global_position = friendly_buff_holder.global_position
	new_buff.initialize(self, buff)
func instance_enemy_buff(buff: BuffData):
	var new_buff: BuffHolder = buffScene.instantiate()
	enemy_buff_holder.add_child(new_buff)
	new_buff.global_position = enemy_buff_holder.global_position
	selectButton.tooltip_text = "defense " +str(defense)
	new_buff.initialize(self, buff)
func set_friendly_select_disabled():
	friendlySelectButton.hide()
func set_friendly_select_enabled():
	friendlySelectButton.show()
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
func spawn_aoe_sprite_no_damage(spriteData: SpriteFrames):
	var new_anim: AoeAnim = aoeanimScene.instantiate()
	add_child(new_anim)
	new_anim.global_position = self.global_position
	new_anim.sprite_frames = spriteData
	new_anim.initialize()

func _on_friendly_select_button_pressed() -> void:
	FRIENDLYSELECTED.emit(self)
