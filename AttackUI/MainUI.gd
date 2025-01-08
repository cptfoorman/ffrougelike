extends CanvasLayer
class_name UI

@export var attackUI: AttackUI
@export var animPlayer: AnimationPlayer
@export var unit: Unit
@onready var your_turn_label: Label = $TurnLabels/yourTurnLabel
@onready var enemy_turn_label: Label = $TurnLabels/enemyTurnLabel
@onready var reward_ui: RewardUI = $RewardUI

var current_reward_unit: UnitData

signal AttackSelected(unitattack: UnitAttack)
signal AttackDeselected
signal AddedToParty(newPartyUnit: UnitData)
signal UpgradesSelected

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
func reward_ui_slidein():
	animPlayer.play("reward_slidein")
func reset_ui_anim():
	animPlayer.play("attackselectReset")
func _on_attack_ui_attack_decided(unitattack: UnitAttack) -> void:
	attack_ui_slideOut()
	AttackSelected.emit(unitattack)
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
	
func initialize_rewards(rewardUnit: UnitData):
	reward_ui.initialize(rewardUnit)
	reward_ui_slidein()
	current_reward_unit = rewardUnit
	

func _on_add_to_party_pressed() -> void:
	AddedToParty.emit(current_reward_unit)


func _on_upgrade_party_pressed() -> void:
	UpgradesSelected.emit()
