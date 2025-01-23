extends CanvasLayer
class_name UpgradeUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var upgradeButtonScene: PackedScene
@onready var h_box_container: VBoxContainer = %upgrades
@onready var stats: VBoxContainer = %stats
@onready var attacks: VBoxContainer = %attacks
@export var labelScene: PackedScene
@export var currentUpgradeUnit: UnitData

signal UpgradePassed(new_strategy: Base_Unit_Strategy)

func show_upgradeUI(unit: UnitData):
	animation_player.play("upgrade_slidein")
	if currentUpgradeUnit != unit:
		currentUpgradeUnit = unit
		clear_upgradeUI()
		clear_infoUI()
		instance_unit_info(unit)
		var new_strategies: Array[Base_Unit_Strategy]
		new_strategies = get_parent().return_upgrade_strategies()
		for i in 3:
			var new_strategy: Base_Unit_Strategy = new_strategies.pick_random()
			instance_upgrades(new_strategy)
			new_strategies.erase(new_strategy)
			new_strategies.sort()
			new_strategies.resize(new_strategies.size())
func clear_upgradeUI():
	for child in h_box_container.get_children():
		child.queue_free()
		
func clear_infoUI():
	for child in stats.get_children():
		child.queue_free()
	for child in attacks.get_children():
		child.queue_free()
func hide_upgradeUI():
	animation_player.play("upgrade_slideout")

func instance_upgrades(new_upgrade: Base_Unit_Strategy):
	var new_button: UpgradeButton = upgradeButtonScene.instantiate()
	new_button.upgrade = new_upgrade
	new_button.tooltip_text = new_upgrade.description
	new_button.text = new_upgrade.textname
	h_box_container.add_child(new_button)
	new_button.connect("UpgradeChosen", _on_button_upgrade_chosen)
	
func instance_unit_info(unit: UnitData):
	instance_info("Health: ",str(unit.get_unitstats().health), stats)
	instance_info("Strenght: ",str(unit.get_unitstats().strenght), stats)
	instance_info("Inteligence: ",str(unit.get_unitstats().inteligence), stats)
	instance_info("Speed: ",str(unit.get_unitstats().speed), stats)
	instance_info("Defense: ",str(unit.get_unitstats().defense), stats)
	for attack in unit.get_unitAttacks():
		instance_info(attack.attack_name,str(attack.attackdmg), attacks)
	for strategy in unit.unitStrategies:
		if strategy.chardef != "ALL":
			instance_info_strats(strategy.textname, strategy.description, attacks)
func instance_info(displayName: String,displayText: String, node: VBoxContainer):
	var new_label: Label = labelScene.instantiate()
	node.add_child(new_label)
	new_label.text = displayName + " " +displayText
func instance_info_strats(displayName: String,displayText: String, node: VBoxContainer):
	var new_label: Label = labelScene.instantiate()
	node.add_child(new_label)
	new_label.text = displayName + " 
	" +displayText
func _on_button_upgrade_chosen(new_strategy: Base_Unit_Strategy) -> void:
	UpgradePassed.emit(new_strategy)
