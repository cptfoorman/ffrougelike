extends Node2D
class_name BuffHolder




@onready var buff_anims: AnimatedSprite2D = %buffAnims
@export var buffData: BuffData
var one_time_buff: bool
var current_buff_duration: int
var current_buff_max_duration: int
var current_unit: Unit


func initialize(unit: Unit, buff: BuffData):
	buffData = buff
	if buffData.buffAnim != null:
		buff_anims.sprite_frames = buffData.buffAnim
		buff_anims.play("default")
	current_buff_max_duration = buffData.buffDuration
	current_buff_duration = buffData.buffDuration
	buffData.apply_buff(unit)
	current_unit = unit
	one_time_buff = buff.one_time_buff
	unit.connect("DAMAGED", _on_damaged)
	

func _on_damaged(damage: int):
	if one_time_buff == true:
		clear_buff(damage)

func reduce_duration():
	current_buff_duration-=1
	buffData.apply_end_turn_status(current_unit)
	if current_buff_duration<=0:
		clear_buff(0)
func clear_buff(damage: int):
	buffData.deapply_buff(current_unit, damage)
	self.queue_free()
