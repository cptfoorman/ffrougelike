extends Control
class_name AttackUI
@onready var attack_container: VBoxContainer = %AttackContainer
@onready var items_container: HFlowContainer = %ItemsContainer

signal AttackDecided(unitattack: UnitAttack)
signal ItemSelected(item: Item)
signal TurnPassed

func create_attack_button(attackName: String, attackdmg: float, attackdesc: String, attackReference:UnitAttack, unitReference: Unit):
	var new_attack_button: AttackButton = AttackButton.new()
	new_attack_button.text = attackName+" " + str(attackdmg) + " dmg"
	new_attack_button.tooltip_text = attackdesc
	new_attack_button.unitReference = unitReference
	new_attack_button.attackReference = attackReference
	attack_container.add_child(new_attack_button)
	new_attack_button.connect_signals()
	new_attack_button.connect("AttackPressed", _on_attack_button_attack_pressed)
func clear_attack_buttons():
	for child in attack_container.get_children():
		child.queue_free()
	for child in items_container.get_children():
		child.queue_free()
		
func create_move_button(attackName: String, attackdmg: float, attackdesc: String, unitReference: Unit):
	var new_move_button: Button = Button.new()
	new_move_button.text = attackName
	new_move_button.tooltip_text = attackdesc+" " + str(attackdmg) + " dmg"
	new_move_button.unitReference = unitReference
	#new_move_button.attackReference = attackReference
	#attack_container.add_child(new_attack_button)
	new_move_button.connect_signals()
	new_move_button.connect("AttackPressed", _on_attack_button_attack_pressed)

func _on_attack_button_attack_pressed(attack: UnitAttack) -> void:
	AttackDecided.emit(attack)


func create_item_button(item: Item):
	var new_hbox:= HBoxContainer.new()
	items_container.add_child(new_hbox)
	var new_item_button: ItemButton = ItemButton.new()
	new_item_button.text = item.name
	new_item_button.itemReference = item
	new_hbox.add_child(new_item_button)
	new_item_button.connect_signals()
	new_item_button.connect("ITEMSELECTED", _on_item_selected)
	var new_item_display:= TextureRect.new()
	new_hbox.add_child(new_item_display)
	new_item_display.texture = item.icon
	
func _on_item_selected(item: Item):
	ItemSelected.emit(item)


func _on_pass_pressed() -> void:
	TurnPassed.emit()
