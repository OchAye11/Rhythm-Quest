extends Sprite2D

@export var button_input: String
@export var pressed_frame: int

var moving_ring: Area2D = null
var perfect_entered: bool = false
var good_entered: bool = false
var okay_entered: bool = false

func _on_ready() -> void:
	$Flash.frame = pressed_frame


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(button_input): #Checks if the requested string is an actual input map
		if event.is_action_pressed(button_input): #Checks if the requested key has been pressed
			if moving_ring != null:
				if perfect_entered:
					get_parent().increment_score(3)
					moving_ring._destroy(3)
				elif good_entered:
					get_parent().increment_score(2)
					moving_ring._destroy(2)
				elif okay_entered:
					get_parent().increment_score(1)
					moving_ring._destroy(1)
				_defaults()
			else:
				if Global.dropped_axe and Global.level6_1:
					get_parent().increment_score(0)
			$Flash.visible = true
		elif event.is_action_released(button_input):
			$Flash.visible = false

func _on_perfect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		perfect_entered = true


func _on_perfect_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		perfect_entered = false


func _on_great_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		good_entered = true


func _on_great_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		good_entered = false


func _on_okay_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		okay_entered = true
		moving_ring = area


func _on_okay_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("MovingRings"):
		okay_entered = false
		moving_ring = null

func _defaults() -> void:
	good_entered = false
	okay_entered = false
	perfect_entered = false
	moving_ring = null
