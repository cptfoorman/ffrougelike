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
var currentAttack: UnitAttack
@export var selectButton: Button
@onready var healthbar: ProgressBar = %health

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
	return unitattacks
func getName():
	return unitsstats.name
func take_damage(damage: float):
	health -= damage
	prints(unitsstats.name, health)
	healthbar.value = health
	if health <= 0:
		queue_free()
		prints(unitsstats.name + " died")

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

func set_button_disabled():
	selectButton.hide()
func set_button_enabled():
	selectButton.show()
func _on_select_button_mouse_exited() -> void:
	unset_hover()
