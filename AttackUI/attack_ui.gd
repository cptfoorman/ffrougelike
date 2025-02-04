extends Control
class_name AttackUI
@onready var attack_container: VBoxContainer = %AttackContainer
@onready var attack_container_2: VBoxContainer = %AttackContainer2
@onready var attack_container_3: VBoxContainer = %AttackContainer3
@onready var attack_container_4: VBoxContainer = %AttackContainer4

@onready var movement_container: VBoxContainer = %MovementContainer
@onready var main_controll_panel: VBoxContainer = %MainControllPanel
@onready var main_panelback: Button = %mainPanelback
@onready var items_container: HBoxContainer = %ItemsContainer
@onready var scroll_bar: ScrollContainer = %ScrollBar

signal AttackDecided(unitattack: UnitAttack)
signal ItemSelected(item: Item)
signal TurnPassed

var current_attacks: int

func create_attack_button(attackName: String, attackdmg: float, attackdesc: String, attackReference:UnitAttack, unitReference: Unit):
	var new_attack_button: AttackButton = AttackButton.new()
	var modifier_increase: int
	current_attacks +=1
	match unitReference.attackModifier:
		unitReference.MainAttackModifier.strenght:
			modifier_increase = unitReference.strenght
		unitReference.MainAttackModifier.inteligence:
			modifier_increase = unitReference.inteligence
	new_attack_button.text = attackName+" " + str(attackdmg) + " dmg" + "+" + str(modifier_increase)
	new_attack_button.tooltip_text = attackdesc
	new_attack_button.unitReference = unitReference
	new_attack_button.attackReference = attackReference
	match current_attacks:
		1:
			attack_container.add_child(new_attack_button)
		2:
			attack_container.add_child(new_attack_button)
		3:
			attack_container.add_child(new_attack_button)
		4:
			attack_container.add_child(new_attack_button)
		5:
			attack_container_2.add_child(new_attack_button)
		6:
			attack_container_2.add_child(new_attack_button)
		7:
			attack_container_2.add_child(new_attack_button)
		8:
			attack_container_2.add_child(new_attack_button)
		9:
			attack_container_3.add_child(new_attack_button)
		10:
			attack_container_3.add_child(new_attack_button)
		11:
			attack_container_3.add_child(new_attack_button)
		12:
			attack_container_3.add_child(new_attack_button)
		13:
			attack_container_4.add_child(new_attack_button)
		14:
			attack_container_4.add_child(new_attack_button)
		15:
			attack_container_4.add_child(new_attack_button)
		16:
			attack_container_4.add_child(new_attack_button)
			
	new_attack_button.connect_signals()
	new_attack_button.connect("AttackPressed", _on_attack_button_attack_pressed)
func clear_attack_buttons():
	current_attacks = 0
	attack_container.hide()
	attack_container_2.hide()
	attack_container_3.hide()
	attack_container_4.hide()
	movement_container.hide()
	items_container.hide()
	scroll_bar.hide()
	main_controll_panel.show()
	main_panelback.hide()
	for child in attack_container.get_children():
		child.queue_free()
	for child in attack_container_2.get_children():
		child.queue_free()
	for child in attack_container_3.get_children():
		child.queue_free()
	for child in attack_container_4.get_children():
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


func _on_attacks_pressed() -> void:
	attack_container.show()
	attack_container_2.show()
	attack_container_3.show()
	attack_container_4.show()
	main_controll_panel.hide()
	scroll_bar.hide()
	movement_container.show()
	main_panelback.show()


func _on_items_pressed() -> void:
	items_container.show()
	main_controll_panel.hide()
	main_panelback.show()
	scroll_bar.show()
	attack_container.hide()
	attack_container_2.hide()
	attack_container_3.hide()
	attack_container_4.hide()


func _on_main_panelback_pressed() -> void:
	attack_container.hide()
	attack_container_2.hide()
	attack_container_3.hide()
	attack_container_4.hide()
	movement_container.hide()
	items_container.hide()
	main_controll_panel.show()
	scroll_bar.hide()
	main_panelback.hide()
