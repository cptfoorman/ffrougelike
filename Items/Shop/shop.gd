extends CanvasLayer
class_name Shop


@export var shopItems: Array[ShopItem]
var playerItems: Array
@onready var shop_item_list: ItemList = %ItemList

var money: int = 200

signal ITEMBOUGHT(item: ShopItem)
signal CONTINUE
func initialize(newShopItems: Array[ShopItem]):
	for item in newShopItems:
		add_shop_item(item)
func add_shop_item(item: ShopItem):
	var item_int: int = shop_item_list.add_item(item.itemName,item.itemIcon, false)
	shop_item_list.set_item_metadata(item_int, item)
	shop_item_list.set_item_tooltip(item_int, str(item.itemCost))


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	var itemData: ShopItem = shop_item_list.get_item_metadata(index)
	if globalSceneLoader.current_money>= itemData.itemCost:
		globalSceneLoader.current_money -= itemData.itemCost
		shop_item_list.remove_item(index)
		ITEMBOUGHT.emit(itemData)


func _on_continue_pressed() -> void:
	CONTINUE.emit()
