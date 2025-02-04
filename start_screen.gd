extends CanvasLayer
class_name StartScreen


@onready var start: Button = %Start
@onready var options: Button = %Options
@onready var quit: Button = %Quit
@onready var top_floor: Label = %topFloor
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var top_floor_num: int =1


#connect("pressed", Callable(get_root(), "_on_start_pressed"))
func initialize(top_floor_check: int):
	start.connect("pressed", Callable(get_tree().get_root(), "_on_start_pressed"))
	if top_floor_num<top_floor_check:
		top_floor_num = top_floor_check
		top_floor.text = "top floor reached: " + str(top_floor_num)
	else:
		top_floor.text = "top floor reached: " + str(top_floor_num)
	animation_player.play("mainMenuSlidein")


func play_slidein():
	animation_player.play("mainMenuSlidein")
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	animation_player.play("mainMenuSlideOut")
	await animation_player.animation_finished
	animation_player.play("optionsSlidein")


func _on_options_exit_pressed() -> void:
	animation_player.play("optionsSlideout")
	await animation_player.animation_finished
	animation_player.play("mainMenuSlidein")
