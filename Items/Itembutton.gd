extends Button
class_name ItemButton


signal ITEMSELECTED(item: Item)


@export var itemReference: Item



func connect_signals():
	connect("pressed", _on_pressed)
	
	
func _on_pressed():
	ITEMSELECTED.emit(itemReference)
