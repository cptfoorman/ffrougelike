extends CanvasLayer
class_name StartScreen


@onready var start: Button = %Start
@onready var options: Button = %Options
@onready var quit: Button = %Quit

#connect("pressed", Callable(get_root(), "_on_start_pressed"))
func initialize():
	start.connect("pressed", Callable(get_tree().get_root(), "_on_start_pressed"))
	


func _on_quit_pressed() -> void:
	get_tree().quit()
