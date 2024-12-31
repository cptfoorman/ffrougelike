extends Control
class_name AttackUI
@onready var attack_container: VBoxContainer = %AttackContainer

signal AttackDecided

func create_attack_button(attackName: String, attackdmg: float, attackdesc: String, attackReference:UnitAttack, unitReference: Unit):
	var new_attack_button: AttackButton = AttackButton.new()
	new_attack_button.text = attackName
	new_attack_button.tooltip_text = attackdesc+" " + str(attackdmg) + " dmg"
	new_attack_button.unitReference = unitReference
	new_attack_button.attackReference = attackReference
	attack_container.add_child(new_attack_button)
	new_attack_button.connect_signals()
	new_attack_button.connect("AttackPressed", _on_attack_button_attack_pressed)
func clear_attack_buttons():
	for child in attack_container.get_children():
		child.queue_free()
		


func _on_attack_button_attack_pressed(attack: UnitAttack) -> void:
	AttackDecided.emit()
