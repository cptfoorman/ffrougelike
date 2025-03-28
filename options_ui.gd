extends Control


@onready var char_unlocked_slider: HSlider = %char_unlocked_slider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	char_unlocked_slider.min_value = 1
	char_unlocked_slider.max_value = globalSceneLoader.availableUnitsArray.size()
	#char_unlocked_slider.value = globalSceneLoader.char_unlocked


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_char_unlocked_slider_value_changed(value: float) -> void:
	pass
	#globalSceneLoader.char_unlocked = value


func _on_char_unlocked_slider_drag_ended(value_changed: bool) -> void:
	globalSceneLoader.char_unlocked = char_unlocked_slider.value
