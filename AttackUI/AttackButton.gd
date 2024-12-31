extends Button
class_name AttackButton

@export var unitReference: Unit
@export var attackReference: UnitAttack



signal AttackPressed(attack: UnitAttack)

func connect_signals() -> void:
	connect("pressed", _on_pressed)
	unitReference.connect_attack_pressed(self)
	
func _on_pressed() -> void:
	AttackPressed.emit(attackReference)
