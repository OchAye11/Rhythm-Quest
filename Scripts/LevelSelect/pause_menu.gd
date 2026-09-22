extends CanvasLayer

var audio_id

func _on_ready() -> void:
	visible = false
	get_tree().paused = false
	audio_id = AudioServer.get_bus_index("Master")
	$VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(audio_id))

func _input(event):
	if event.is_action_pressed("Pause"):
		if !get_parent().dialogue_finished:
			if visible:
				visible = false
				get_parent().is_paused = false
			else:
				visible = true
				get_parent().is_paused = true
		else:
			if get_tree().paused:
				visible = false
				get_tree().paused = false
				get_parent().is_paused = false
			else:
				visible = true
				get_tree().paused = true
				get_parent().is_paused = true

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_volume_slider_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_id, db)
