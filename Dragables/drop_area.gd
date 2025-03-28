extends Area2D
class_name DropArea

var unit_data: UnitData
@export var collision: CollisionShape2D
	
signal unitDataCounted(unitdata: UnitData)

@onready var red: Sprite2D = %red
@onready var yellow: Sprite2D = %yellow

func _ready() -> void:
	red.hide()
	yellow.show()
	
func get_unit_data()->UnitData:
	return unit_data

func _on_dragable_dropped(unit_data: UnitData) -> void:
	unitDataCounted.emit(unit_data)
	yellow.hide()
	red.show()
	self.unit_data = unit_data
	var newunitstats: UnitStats = unit_data.get_unitstats()
	print(newunitstats.name)


func _on_dragable_taken_away(units_data: UnitData) -> void:
	red.hide()
	yellow.show()
	self.unit_data = null
	var curr_cons = get_incoming_connections()
	for cur_conn in curr_cons:
		cur_conn.signal.disconnect(cur_conn.callable)
		print("signal disconected")
		print(units_data)
	
	
	
	
