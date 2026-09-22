extends Sprite2D

var click_once: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()) and !click_once:
			get_parent().start_fade = true
			click_once = true

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(0.45, 0.55)


func _on_area_2d_mouse_exited() -> void:
	scale = Vector2(0.4, 0.5)
