extends AnimatedSprite2D
class_name AoeAnim


func initialize():
	play("default")
	var new_tween:= create_tween()
	new_tween.tween_property(self, "position", Vector2(35,0),2.3)
	await new_tween.finished
	queue_free()
