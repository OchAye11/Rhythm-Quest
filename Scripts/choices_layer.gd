extends CanvasLayer

var all_choices: Dictionary

signal choice_made(next_node: String)

func set_choices(choices: Dictionary):
	var key_choices = choices.keys()
	
	all_choices = choices
	
	if key_choices.size() == 2:
		$Button.text = key_choices[0]
		$Button2.text = key_choices[1]
		$Button3.visible = false
	else:
		$Button.text = key_choices[0]
		$Button2.text = key_choices[1]
		$Button3.visible = true
		$Button3.text = key_choices[2]

func _on_button_pressed() -> void:
	choice_made.emit(all_choices[$Button.text])

func _on_button_2_pressed() -> void:
	choice_made.emit(all_choices[$Button2.text])

func _on_button_3_pressed() -> void:
	choice_made.emit(all_choices[$Button3.text])
