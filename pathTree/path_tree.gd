extends Node2D
class_name PathTree


@onready var control: Control = %Control
@onready var markerstash: Node2D = %markerstash


@export var leftPathArray: Array[EventButton]
@export var middlePathArray: Array[EventButton]
@export var rightPathArray: Array[EventButton]

enum CurrentPath {left,middle,right}
@export var currentPath: CurrentPath
@export var current_events: Array[int]
@export var marker_array: Array[Marker2D]

@export var current_path_position: int

signal EventSent(eventNumber: int)

func initialize(pathPosition: int, events: Array[int] ) -> void:
	current_path_position = pathPosition
	set_current_events(events)
	#await get_tree().create_timer(0.5)
	fill_marker_array()
	#await get_tree().create_timer(0.5)
	spawn_buttons()
	set_current_button()

func set_current_button():
	for button in leftPathArray:
		button.set_deferred("disabled", true)
	var current_button: EventButton = leftPathArray[current_path_position]
	current_button.set_deferred("disabled", false)
	current_button.connect("EventChosen", _on_event_button_event_chosen)

func set_current_events(events: Array[int]):
	current_events.append_array(events)

func spawn_buttons():
	for i in 10:
		spawn_event_button(current_events[i], marker_array[i].global_position)


func fill_marker_array():
	for child in markerstash.get_children():
		if child is Marker2D:
			marker_array.append(child)
			


func spawn_event_button(event_number: int, pos: Vector2):
	var new_event_button:= EventButton.new()
	control.add_child(new_event_button)
	new_event_button.initialize(event_number)
	new_event_button.global_position = pos
	leftPathArray.append(new_event_button)
	


func _on_event_button_event_chosen(eventNum: int) -> void:
	EventSent.emit(eventNum)
