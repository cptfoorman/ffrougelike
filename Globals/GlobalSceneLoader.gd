extends Node
class_name SceneLoader


@export var gameboard:= preload("res://gameboard.tscn")
@export var partybuilder:= preload("res://PartyBuilder/party_builder.tscn")
@export var upgradescene:= preload("res://UnitUpgrade.tscn")
@export var startscreen:= preload("res://start_screen.tscn")
@export var pathTree:= preload("res://pathTree/path_tree.tscn")
#@export var startscreen:= preload()
var availableUnitsArray: Array[UnitData] = [
	preload("res://unit/UnitResouces/UnitData/Friendly/BowmanData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/LegionData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/Reader.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/WaterBowman.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/RavenData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/WitchData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/magueData.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/Dwarwen.tres"),
	preload("res://unit/UnitResouces/UnitData/Friendly/CrusaderData.tres"),
	]
var availableEnemyUnitsArray: Array[UnitData] =[
	preload("res://unit/UnitResouces/UnitData/Enemy/BowmanDataEnemy.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/RavenDataEnemy.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/magueEnemyData.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/EnemyDwarwen.tres")]
var availableEnemyUnitsTierTwoArray: Array[UnitData] =[
	preload("res://unit/UnitResouces/UnitData/Enemy/BowmanT2.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/RavenT2.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/MagueT2.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/CorruptedPriest.tres")]
var bossEnemyArray: Array[UnitData] = [
	preload("res://unit/UnitResouces/UnitData/Enemy/bosses/BossPriest.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/bosses/BossMage.tres"),
	preload("res://unit/UnitResouces/UnitData/Enemy/bosses/DwarwenBoss.tres")]
	
var availableItemsArray: Array[Item] = [preload("res://Items/ItemsResources/PotionOfHeal.tres")]


var clonedUnitsArray: Array[UnitData]
var currentUnitsArray: Array[UnitData]
var currentunlockedUnitsArray: Array[UnitData]
var currentItemsArray: Array[Item]

var current_party_builder: PartyBuilder
var current_gameboard: Gameboard
var current_start_screen: StartScreen
var current_upgradescene: UnitUpgrader
var current_path_tree: PathTree

var current_floor: int = -1
var current_event_array: Array[int]

var currentdiff: int = 1
var char_unlocked: int = 1

func _ready() -> void:
	set_new_event_array()
	get_current_start_screen()
	await get_tree().create_timer(0.5).timeout
	connect_start_screen_buttons()
	clone_items()
	

func get_current_start_screen():
	current_start_screen = get_tree().get_first_node_in_group("StartScreen")

func connect_start_screen_buttons():
	current_start_screen.start.connect("pressed", _on_start_button_pressed)
	
	
func set_new_event_array():
	current_event_array.resize(0)
	var possible_events_array: Array[int] = [0,0,1,2,2,1,1,1,2,1,1,1,1,1,0,0,0,0]
	for i in 10:
		current_event_array.append(possible_events_array.pick_random())

func clone_items():
	for item in availableItemsArray:
		currentItemsArray.append(item.duplicate(true))
		currentItemsArray.append(item.duplicate(true))

func _on_start_button_pressed():
	clone_unit_data()
	await get_tree().create_timer(0.3).timeout
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
	clonedUnitsArray.resize(0)
	for i in char_unlocked:
		var new_data = availableUnitsArray[i].duplicate(true)
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
	instantiate_gameboard(false)
func get_current_items_array()->Array[Item]:
	return currentItemsArray
	
func set_current_items_array(itemArray: Array[Item]):
	currentItemsArray.resize(0)
	currentItemsArray.append_array(itemArray)
func get_current_party_array()->Array[UnitData]:
	return currentUnitsArray
func set_current_party_array(unitArray: Array[UnitData]):
	currentUnitsArray.resize(0)
	currentUnitsArray.append_array(unitArray)
func get_boss_enemy_array()->Array[UnitData]:
	var new_array: Array[UnitData]
	new_array.append(bossEnemyArray.pick_random())
	return new_array
	

func instantiate_gameboard(elite: bool):
	char_unlocked+= wrapi(1, 1, 9)
	get_tree().change_scene_to_packed(gameboard)
	await get_tree().create_timer(0.5).timeout
	get_current_gameboard()
	await get_tree().create_timer(0.5).timeout
	initialize_current_gameboard(elite)
	
func get_current_gameboard():
	current_gameboard = get_tree().get_first_node_in_group("Gameboard")
func initialize_current_gameboard(elite: bool):
	if elite == false:
		current_gameboard.initialize(get_current_party_array(), currentdiff, get_current_enemy_array(), get_current_items_array())
	else:
		current_gameboard.initialize(get_current_party_array(), currentdiff+2, get_current_enemy_array(),get_current_items_array())
func get_current_enemy_array()->Array[UnitData]:
	return availableEnemyUnitsArray
	
func instantiate_boss_gameboard():
	char_unlocked+= wrapi(1, 1, 9)
	get_tree().change_scene_to_packed(gameboard)
	await get_tree().create_timer(0.5).timeout
	get_current_gameboard()
	await get_tree().create_timer(0.5).timeout
	initialize_current_gameboard_for_boss()
func initialize_current_gameboard_for_boss():
	current_gameboard.initialize(get_current_party_array(), 5, get_boss_enemy_array(), get_current_items_array())
func instantiate_upgrader(new_unit_array: Array[UnitData]):
	set_current_party_array(new_unit_array)
	get_tree().change_scene_to_packed(upgradescene)
	await get_tree().create_timer(0.5).timeout
	get_current_party_upgrade_scene()
	await get_tree().create_timer(0.5).timeout
	initialize_current_upgrader()

func instantiate_map_upgrader(new_unit_array: Array[UnitData]):
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
	current_floor = -1
	set_new_event_array()
	get_tree().change_scene_to_packed(startscreen)
	await get_tree().create_timer(0.5).timeout
	get_current_start_screen()
	await get_tree().create_timer(0.5).timeout
	connect_start_screen_buttons()
	current_start_screen.initialize(currentdiff)
	currentdiff = 1
	
	
func instantiate_path_tree():
	current_floor += 1
	get_tree().change_scene_to_packed(pathTree)
	await get_tree().create_timer(0.5).timeout
	get_current_path_tree_scene()
	await get_tree().create_timer(0.5).timeout
	initialize_path_tree()
	connect_path_tree_signal()
	
func get_current_path_tree_scene():
	current_path_tree = get_tree().get_first_node_in_group("PathTree")
func initialize_path_tree():
	current_path_tree.initialize(current_floor, current_event_array)
func connect_path_tree_signal():
	current_path_tree.connect("EventSent", _on_event_sent)
func add_next_tier_unit():
	availableEnemyUnitsArray.append(availableEnemyUnitsTierTwoArray.pick_random())
func _on_event_sent(eventNum: int)-> void:
	currentdiff+= 1
	match eventNum:
		0:
			instantiate_gameboard(false)
		1:
			instantiate_map_upgrader(get_current_party_array())
		2:
			instantiate_gameboard(true)
		3:
			instantiate_boss_gameboard()
			set_new_event_array()
			current_floor = -1
			add_next_tier_unit()
