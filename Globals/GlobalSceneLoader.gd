extends Node
class_name SceneLoader


@export var gameboard:= preload("res://gameboard.tscn")
@export var partybuilder:= preload("res://PartyBuilder/party_builder.tscn")
@export var upgradescene:= preload("res://UnitUpgrade.tscn")
@export var startscreen:= preload("res://start_screen.tscn")
#@export var startscreen:= preload()
var availableUnitsArray: Array[UnitData] = [
	preload("res://unit/UnitResouces/UnitData/Friendly/BowmanData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/RavenData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/magueData.tres")]
var availableEnemyUnitsArray: Array[UnitData] =[
	preload("res://unit/UnitResouces/UnitData/Enemy/BowmanDataEnemy.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/RavenDataEnemy.tres"),]
var clonedUnitsArray: Array[UnitData]
var currentUnitsArray: Array[UnitData]

var current_party_builder: PartyBuilder
var current_gameboard: Gameboard
var current_start_screen: StartScreen
var current_upgradescene: UnitUpgrader

var currentdiff: int = 1

func _ready() -> void:
	get_current_start_screen()
	clone_unit_data()
	await get_tree().create_timer(0.5).timeout
	connect_start_screen_buttons()

func get_current_start_screen():
	current_start_screen = get_tree().get_first_node_in_group("StartScreen")

func connect_start_screen_buttons():
	current_start_screen.start.connect("pressed", _on_start_button_pressed)
	
	
	
func _on_start_button_pressed():
	instantiate_partyBuilder()

func instantiate_partyBuilder():
	get_tree().change_scene_to_packed(partybuilder)
	await get_tree().create_timer(0.5).timeout
	get_current_partyBuilder()
	await get_tree().create_timer(0.5).timeout
	initialize_partyBuilder()
	connect_party_builder_buttons()

func clone_random_unit()->UnitData:
	var new_clone: UnitData = availableUnitsArray.pick_random().duplicate(true)
	return new_clone
	

func clone_unit_data():
	for data in availableUnitsArray:
		var new_data = data.duplicate(true)
		clonedUnitsArray.append(new_data)
func get_current_partyBuilder():
	current_party_builder = get_tree().get_first_node_in_group("PartyBuilder")
func initialize_partyBuilder():
	current_party_builder.initialize(clonedUnitsArray)
func connect_party_builder_buttons():
	current_party_builder.connect("UnitsReady", _on_units_ready)
func _on_units_ready(units: Array[UnitData]):
	currentUnitsArray.resize(0)
	currentUnitsArray.append_array(units)
	print("button2")
	instantiate_gameboard()
	
func get_current_party_array()->Array[UnitData]:
	return currentUnitsArray
func set_current_party_array(unitArray: Array[UnitData]):
	currentUnitsArray.resize(0)
	currentUnitsArray.append_array(unitArray)


func instantiate_gameboard():
	get_tree().change_scene_to_packed(gameboard)
	await get_tree().create_timer(0.5).timeout
	get_current_gameboard()
	await get_tree().create_timer(0.5).timeout
	initialize_current_gameboard()
	
func get_current_gameboard():
	current_gameboard = get_tree().get_first_node_in_group("Gameboard")
func initialize_current_gameboard():
	current_gameboard.initialize(get_current_party_array(), currentdiff)

func instantiate_upgrader(new_unit_array: Array[UnitData]):
	currentdiff+= 1
	set_current_party_array(new_unit_array)
	get_tree().change_scene_to_packed(upgradescene)
	await get_tree().create_timer(0.5).timeout
	get_current_party_upgrade_scene()
	await get_tree().create_timer(0.5).timeout
	initialize_current_upgrader()

func get_current_party_upgrade_scene():
	current_upgradescene = get_tree().get_first_node_in_group("UnitUpgrader")
func initialize_current_upgrader():
	current_upgradescene.initialize(get_current_party_array())


func instantiate_start_screen():
	currentdiff = 3
	get_tree().change_scene_to_packed(startscreen)
	await get_tree().create_timer(0.5).timeout
	get_current_start_screen()
	await get_tree().create_timer(0.5).timeout
	connect_start_screen_buttons()
