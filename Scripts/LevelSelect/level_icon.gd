extends Sprite2D

@export var level : String

func _on_ready() -> void:
	if Global.get(level):
		frame = 0
	else:
		frame = 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()):
			if frame == 0:
				print(level)
				get_tree().change_scene_to_file("res://Levels/" + level + ".tscn")

func _on_area_2d_mouse_entered() -> void:
	if frame == 0:
		scale = Vector2(0.6, 0.6)


func _on_area_2d_mouse_exited() -> void:
	if frame == 0:
		scale = Vector2(0.5, 0.5)
