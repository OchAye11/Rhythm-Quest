extends Sprite2D

@export var negation_type: String

signal negation_pressed(type)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()):
			emit_signal("negation_pressed", negation_type)
