extends TextureButton
class_name EventButton

@export var nextLocation:EventButton
@export var connection_line: Line2D

enum PathEvent {COMBAT, REST, HARDCOMBAT}
@export var currentPathEvent: PathEvent

const CAMP = preload("res://assets/icons/camp.png")
const CAMPHIGHLIGHT = preload("res://assets/icons/camphighlight.png")
const ELITE = preload("res://assets/icons/elite.png")
const ELITEHIGHLIGHT = preload("res://assets/icons/elitehighlight.png")
const SWORD = preload("res://assets/icons/sword.png")
const SWORDHIGHLIGHT = preload("res://assets/icons/swordhighlight.png")


signal EventChosen(eventNum: int)

func initialize(event_number: int):
	connect("pressed", _on_pressed)
	currentPathEvent = event_number
	match currentPathEvent:
		PathEvent.COMBAT:
			texture_normal = SWORD
			texture_hover = SWORDHIGHLIGHT
			texture_pressed = SWORD
		PathEvent.REST:
			texture_normal = CAMP
			texture_hover = CAMPHIGHLIGHT
			texture_pressed = CAMP
		PathEvent.HARDCOMBAT:
			texture_normal = ELITE
			texture_hover = ELITEHIGHLIGHT
			texture_pressed = ELITE
func get_event_number()->int:
	var event_number: int = currentPathEvent
	return event_number

func _on_pressed() -> void:
	EventChosen.emit(get_event_number())
	print("button:" + str(get_event_number()))
