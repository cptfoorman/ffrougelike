extends Area2D
class_name Dragable


var initial_position: Vector2
var is_dragging: bool = false
var drag_speed: float = 50

@export var unitData: UnitData
@export var animation: AnimatedSprite2D
var current_area: DropArea = null

signal Dropped(unit_data: UnitData)
signal TakenAway(unit_data: UnitData)

# Called when the node enters the scene tree for the first time.
func initialize() -> void:
	initial_position = global_position
	animation.sprite_frames = unitData.get_spriteframes()
	animation.play("idle")

func get_unit_data()-> UnitData:
	return unitData
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_dragging:
		global_position = lerp(global_position, get_global_mouse_position(), delta*drag_speed)
		
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		is_dragging = true
		TakenAway.emit(unitData)
		
func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and is_dragging:
		is_dragging = false
		var overlapingAreas = get_overlapping_areas()
		if overlapingAreas.is_empty():
			TakenAway.emit(unitData)
			#if current_area != null:
				#disconnect("Dropped", current_area._on_dragable_dropped)
			reset_position()
		else :
			for area in overlapingAreas:
				if area is DropArea:
					current_area = area
					connect("Dropped", Callable(area, "_on_dragable_dropped"))
					connect("TakenAway", Callable(area, "_on_dragable_taken_away"))
					Dropped.emit(unitData)
					global_position = area.global_position
				if area is Dragable:
					area.TakenAway.emit(area.unitData)
					area.reset_position()
				
func reset_position():
	global_position = initial_position
