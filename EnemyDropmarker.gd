extends Marker2D
class_name DropMarker

var unit_data: UnitData

func set_unit_data(unitData: UnitData):
	self.unitData = unit_data

func get_unit_data()->UnitData:
	return unit_data
