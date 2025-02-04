extends Node2D
class_name UnitUpgrader

@export var upgradeUI: UpgradeUI
@export var unitHolder: UnitHolder
@export var possibleUpgrades: Array[Base_Unit_Strategy]
var current_unit: UnitData
@onready var craft_item_drop_area: CraftItemDropArea = %CraftItemDropArea
@onready var upgrade_drop_area: UpgradeDropArea = %UpgradeDropArea



func initialize(units: Array[UnitData]):
	unitHolder.initialize(units)
	upgradeUI.show_main_choice_menu()

func _on_upgrade_drop_area_unit_taken(unit: UnitData) -> void:
	if current_unit != null:
		current_unit = null
		upgradeUI.hide_upgradeUI()
	

func _on_upgrade_drop_area_unit_data_counted(unitdata: UnitData) -> void:
	current_unit = unitdata
	upgradeUI.show_upgradeUI(unitdata)
	
func return_new_units()->Array[UnitData]:
	var new_units_array: Array[UnitData]
	for child in unitHolder.get_children():
		if child is Dragable:
			new_units_array.append(child.get_unit_data())
			print("appended strategy unit")
	return new_units_array

func _on_canvas_layer_upgrade_passed(new_strategy: Base_Unit_Strategy) -> void:
	current_unit.add_strategy(new_strategy)
	print("giving strategy")
	globalSceneLoader.set_current_party_array(return_new_units())
	await get_tree().create_timer(0.5).timeout
	globalSceneLoader.instantiate_path_tree()
	
func return_upgrade_strategies()->Array[Base_Unit_Strategy]:
	var chardef: String = current_unit.get_unitstats().name
	var new_array: Array[Base_Unit_Strategy]
	for strategy in possibleUpgrades:
		if strategy.chardef == "ALL" or strategy.chardef == current_unit.get_unitstats().name:
			if !new_array.has(strategy):
				new_array.append(strategy)
	return new_array


func _on_craft_item_drop_area_unit_taken(unit: UnitData) -> void:
	upgradeUI.hide_crafting_ui()


func _on_craft_item_drop_area_unit_data_counted(unitdata: UnitData) -> void:
	upgradeUI.show_craft_item_ui(unitdata)


func _on_rest_pressed() -> void:
	upgradeUI.hide_main_choice_menu()
	globalSceneLoader.lvlUpMultiplier += 1
	globalSceneLoader.set_current_party_array(return_new_units())
	await get_tree().create_timer(0.5).timeout
	globalSceneLoader.instantiate_path_tree()


func _on_upgrade_pressed() -> void:
	upgradeUI.hide_main_choice_menu()
	upgrade_drop_area.show()
	craft_item_drop_area.collision.set_deferred("disabled", true)


func _on_craft_pressed() -> void:
	upgradeUI.hide_main_choice_menu()
	craft_item_drop_area.show()
	upgrade_drop_area.collision.set_deferred("disabled", true)


func _on_canvas_layer_item_crafted(new_item: Item) -> void:
	globalSceneLoader.currentItemsArray.append(new_item.duplicate(true))
	print("giving item")
	globalSceneLoader.set_current_party_array(return_new_units())
	await get_tree().create_timer(0.5).timeout
	globalSceneLoader.instantiate_path_tree()
