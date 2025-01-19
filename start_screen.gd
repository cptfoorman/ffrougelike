extends CanvasLayer
class_name StartScreen


@onready var start: Button = %Start
@onready var options: Button = %Options
@onready var quit: Button = %Quit
@onready var top_floor: Label = %topFloor

var top_floor_num: int 


#connect("pressed", Callable(get_root(), "_on_start_pressed"))
func initialize(top_floor_check: int):
	start.connect("pressed", Callable(get_tree().get_root(), "_on_start_pressed"))
	if top_floor_num<top_floor_check:
		top_floor_num = top_floor_check
		top_floor.text = "top floor reached: " + str(top_floor_num)
	else:
		top_floor.text = "top floor reached: " + str(top_floor_num)

func _on_quit_pressed() -> void:
	get_tree().quit()
