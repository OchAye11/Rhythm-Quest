extends Control

@export var audio_name: String

var button_type: String = "null"

var audio_id

func _on_ready() -> void:
	audio_id = AudioServer.get_bus_index(audio_name)

func _on_play_pressed() -> void:
	button_type = "Play"
	$Fade_Trans.show()
	$Fade_Trans/FadeTimer.start()
	$Fade_Trans/AnimationPlayer.play("fade_in")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_fade_timer_timeout() -> void:
	if button_type == "Play":
		get_tree().change_scene_to_file("res://Levels/LevelSelect.tscn")


func _on_settings_pressed() -> void:
	$Settings.visible = true
	$MenuButtons.visible = false
	$NameLabel.visible = false

func _on_button_pressed() -> void:
	$Settings.visible = false
	$MenuButtons.visible = true
	$NameLabel.visible = true

func _on_volume_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_id, db)
