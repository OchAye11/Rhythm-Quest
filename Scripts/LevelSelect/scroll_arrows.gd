extends Sprite2D

@export var direction: String = ""

var inside: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()) and inside:
			get_parent().moving = true
			get_parent().direction = direction
	elif event.is_action_released("click"):
		get_parent().moving = false
	


func _on_area_2d_mouse_entered() -> void:
	inside = true
	if frame == 0 or frame == 1:
		scale = Vector2(0.45, 0.45)


func _on_area_2d_mouse_exited() -> void:
	inside = false
	if frame == 0 or frame == 1:
		scale = Vector2(0.4, 0.4)
