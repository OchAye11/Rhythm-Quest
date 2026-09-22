extends ColorRect

@export var button_input: String
@export var normal_color: String
@export var pressed_color: String

var moving_square: Area2D = null
var perfect_entered: bool = false
var good_entered: bool = false

func _on_ready() -> void:
	$ColorRect.color = normal_color

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(button_input): #Checks if the requested string is an actual input map
		if event.is_action_pressed(button_input): #Checks if the requested key has been pressed
			if moving_square != null:
				if perfect_entered:
					get_parent().increment_score(3)
					moving_square._destroy(3)
				elif good_entered:
					get_parent().increment_score(2)
					moving_square._destroy(2)
				_defaults()
			else:
				get_parent().increment_score(0)
				$ColorRect.color = pressed_color
		elif event.is_action_released(button_input):
			$ColorRect.color = normal_color

func _defaults():
	good_entered = false
	perfect_entered = false
	moving_square = null

func _on_perfect_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("MovingSquare"):
		perfect_entered = true

func _on_perfect_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("MovingSquare"):
		perfect_entered = false
		
func _on_good_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("MovingSquare"):
		good_entered = true
		moving_square = area

func _on_good_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("MovingSquare"):
		good_entered = false
		moving_square = null
