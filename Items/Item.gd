extends Resource
class_name Item

@export var anims: SpriteFrames
@export var icon: Texture2D
@export var itemfxanims: SpriteFrames
@export var quantity: int
@export var name: String


func use_item(targets: Array[Unit]):
	pass
