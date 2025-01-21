extends Node2D
class_name ItemBackpack


var items: Array[Item]

func initialize(newItems:Array[Item]):
	items.append_array(newItems)



func use_backpack_item(item: Item, targets: Array[Unit]):
	item.use_item(targets)
	
	
	
func get_current_items()->Array[Item]:
	return items


func remove_item(item: Item):
	items.erase(item)
	items.sort()
