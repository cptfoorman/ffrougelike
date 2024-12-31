extends CanvasLayer
class_name UI

@export var attackUI: AttackUI
@export var animPlayer: AnimationPlayer
@export var unit: Unit
@onready var your_turn_label: Label = $TurnLabels/yourTurnLabel
@onready var enemy_turn_label: Label = $TurnLabels/enemyTurnLabel

signal AttackSelected
signal AttackDeselected


func initialize_attack_ui(unit: Unit):
	attack_ui_slideIn()
	attackUI.clear_attack_buttons()
	for attack in unit.get_attacks():
		attackUI.create_attack_button(attack.attack_name, attack.attackdmg, attack.attack_desc, attack, unit)
	
func attack_ui_slideIn():
	animPlayer.play("slide_in")
func attack_ui_slideOut():
	animPlayer.play("slide_out")
func select_ui_slideOut():
	animPlayer.play("select_slideOut")
func select_ui_slideIn():
	animPlayer.play("select_slideIn")

func reset_ui_anim():
	animPlayer.play("attackselectReset")
func _on_attack_ui_attack_decided() -> void:
	attack_ui_slideOut()
	AttackSelected.emit()
	await animPlayer.animation_finished
	select_ui_slideIn()
	
func set_friendly_turn():
	your_turn_label.show()
	enemy_turn_label.hide()
func set_enemy_turn():
	your_turn_label.hide()
	enemy_turn_label.show()

func _on_back_button_pressed() -> void:
	select_ui_slideOut()
	AttackDeselected.emit()
	await animPlayer.animation_finished
	attack_ui_slideIn()
	
