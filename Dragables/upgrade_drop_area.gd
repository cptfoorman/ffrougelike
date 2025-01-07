extends DropArea
class_name UpgradeDropArea
signal UnitTaken(unit: UnitData)

func _on_dragable_taken_away(unit_data: UnitData) -> void:
	red.hide()
	yellow.show()
	UnitTaken.emit(unit_data)
	unit_data = null
