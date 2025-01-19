extends Resource
class_name BuffData


@export var buffDuration: int
@export var buffAnim: SpriteFrames
@export var one_time_buff: bool


func apply_buff(unit: Unit):
	pass
	
func deapply_buff(unit: Unit,stats: int):
	pass
