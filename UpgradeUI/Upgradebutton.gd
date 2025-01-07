extends Button
class_name UpgradeButton

@export var upgrade: Base_Unit_Strategy

signal UpgradeChosen(new_strategy: Base_Unit_Strategy)

func _ready() -> void:
	text = upgrade.description

func _on_pressed() -> void:
	UpgradeChosen.emit(upgrade)
