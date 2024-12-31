extends Node2D
class_name UnitHolder

@export var dragableScene: PackedScene

@export var availableUnitsArray: Array[UnitData]
@export var dragablesArray: Array[Dragable]



@export var marker_array: Array[Marker2D]
var current_marker_index: int = 0
func _ready() -> void:
	current_marker_index = 0
	fill_marker_array()
	spawn_dragables()
	reset_current_marker_index()
	

func fill_marker_array():
	marker_array.resize(0)
	for child in get_children():
		if child is Marker2D:
			marker_array.append(child)
		else:
			child.queue_free()
			
func get_marker_pos()->Vector2:
	var marker: Marker2D = marker_array[current_marker_index]
	return marker.global_position
func spawn_dragables():
	for unit in availableUnitsArray:
		var newDragableUnit: Dragable = dragableScene.instantiate()
		newDragableUnit.unitData = unit
		add_child(newDragableUnit)
		newDragableUnit.global_position = get_marker_pos()
		current_marker_index += 1
		newDragableUnit.initialize()
		newDragableUnit.animation.flip_h = newDragableUnit.unitData.anim_flip
		dragablesArray.append(newDragableUnit)
		
		
func reset_current_marker_index():
	current_marker_index = 0

func clear_dragables():
	for dragable in dragablesArray:
		dragable.queue_free()
func _on_button_pressed() -> void:
	pass # Replace with function body.
