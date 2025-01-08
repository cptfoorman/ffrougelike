extends Control
class_name RewardUI


@onready var upgrade_party: Button = %upgrade_party
@onready var add_to_party: Button = %add_to_party
@onready var unitsprite: AnimatedSprite2D = %unitsprite


func initialize(unitdata: UnitData):
	unitsprite.sprite_frames = unitdata.get_spriteframes()
	unitsprite.play("idle")
