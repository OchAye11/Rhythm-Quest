extends Sprite2D

@export var button_input: String
@export var base_frame: int
@export var pressed_frame: int

var falling_arrow: Area2D = null
var perfect_entered: bool = false
var good_entered: bool = false
var okay_entered: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(button_input): #Checks if the requested string is an actual input map
		if event.is_action_pressed(button_input): #Checks if the requested key has been pressed
			if falling_arrow != null and get_parent().current_negation == get_parent().damage_type:
				if perfect_entered:
					get_parent().increment_score(3)
					falling_arrow._destroy(3)
				elif good_entered:
					get_parent().increment_score(2)
					falling_arrow._destroy(2)
				elif okay_entered:
					get_parent().increment_score(1)
					falling_arrow._destroy(1)
				_defaults()
			else:
				get_parent().increment_score(0)
			frame = pressed_frame
		elif event.is_action_released(button_input):
			frame = base_frame

func _on_perfect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		perfect_entered = true

func _on_perfect_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		perfect_entered = false

func _on_good_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		good_entered = true

func _on_good_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		good_entered = false

func _on_okay_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		okay_entered = true
		falling_arrow = area

func _on_okay_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("FallingArrow"):
		okay_entered = false
		falling_arrow = null

func _defaults() -> void:
	good_entered = false
	okay_entered = false
	perfect_entered = false
	falling_arrow = null
