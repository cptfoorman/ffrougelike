extends TextureButton
class_name EventButton

@export var nextLocation:EventButton
@export var connection_line: Line2D

enum PathEvent {COMBAT, REST, HARDCOMBAT, BOSS}
@export var currentPathEvent: PathEvent

const CAMP = preload("res://assets/icons/camp.png")
const CAMPHIGHLIGHT = preload("res://assets/icons/camphighlight.png")
const ELITE = preload("res://assets/icons/elite.png")
const ELITEHIGHLIGHT = preload("res://assets/icons/elitehighlight.png")
const SWORD = preload("res://assets/icons/sword.png")
const SWORDHIGHLIGHT = preload("res://assets/icons/swordhighlight.png")
const BOSS = preload("res://assets/icons/boss.png")
const BOSSHIGHLIGHT = preload("res://assets/icons/bosshighlight.png")
const HIGHLIGHTER_FRAMES = preload("res://pathTree/highlighterFrames.tres")

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
		PathEvent.BOSS:
			texture_normal = BOSS
			texture_hover = BOSSHIGHLIGHT
			texture_pressed = BOSS
func get_event_number()->int:
	var event_number: int = currentPathEvent
	return event_number
func instantiate_highlighter():
	var new_anims:= AnimatedSprite2D.new()
	add_child(new_anims)
	new_anims.global_position = self.global_position + Vector2(20, -20)
	new_anims.sprite_frames = HIGHLIGHTER_FRAMES
	new_anims.play("default")
func _on_pressed() -> void:
	EventChosen.emit(get_event_number())
	print("button:" + str(get_event_number()))
