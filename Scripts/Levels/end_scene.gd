extends Node2D




func _on_ready() -> void:
	var score_tween = get_tree().create_tween()
	var combo_tween = get_tree().create_tween()
	var sweat_tween = get_tree().create_tween()
	var sour_tween = get_tree().create_tween()
	
	score_tween.tween_method(count_score, 0, Global.total_score, 3.5)
	combo_tween.tween_method(count_combo, 0, Global.highest_combo, 2)
	sweat_tween.tween_method(count_sweat, 0, Global.sweat_choices, 1)
	sour_tween.tween_method(count_sour, 0, Global.sour_choices, 1)

func count_score(value: float):
	var temp: int = int(value)
	$TextContainer/VBoxContainer/Score.text = "Total Score: " + str(temp)

func count_combo(value: float):
	var temp: int = int(value)
	$TextContainer/VBoxContainer/MaxCombo.text = "Highest Combo: " + str(temp)

func count_sweat(value: float):
	var temp: int = int(value)
	$TextContainer/VBoxContainer/SweatChoices.text = "Sweat Choices: " + str(temp)

func count_sour(value: float):
	var temp: int = int(value)
	$TextContainer/VBoxContainer/SourChoices.text = "Sour Choices " + str(temp)

func _on_button_pressed() -> void:
	$Fade_Trans.show()
	$Fade_Trans/FadeTimer.start()
	$Fade_Trans/AnimationPlayer.play("fade_in")

func _on_fade_timer_timeout() -> void:
	Global.reset()
	get_tree().change_scene_to_file("res://Levels/MainMenu/MainMenu.tscn")
