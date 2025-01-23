extends Node2D
class_name ItemBackpack


@export var items: Array[Item]

func initialize(newItems:Array[Item]):
	set_current_items(newItems)



func use_backpack_item(item: Item, targets: Array[Unit]):
	item.use_item(targets)
	
	
func instantiate_item_use(item: Item):
	var newAnims:= AnimatedSprite2D.new()
	newAnims.sprite_frames = item.anims
	add_child(newAnims)
	newAnims.global_position = self.global_position
	newAnims.play("default")
	await newAnims.animation_finished
	await get_tree().create_timer(0.5).timeout
	newAnims.queue_free()
func set_current_items(newItems:Array[Item]):
	items.resize(0)
	items.append_array(newItems)

func get_current_items()->Array[Item]:
	return items


func remove_item(item: Item):
	globalSceneLoader.remove_item(item)
	items.erase(item)
	items.sort()
	items.resize(items.size())
	
