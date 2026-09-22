extends Node2D

var scale_differnece: float
var speed: float = 0
var hit: bool = false
var input: String = ""
var pos: Vector2 = Vector2(350.0, 262.0)
var can_score: bool = false

func _on_ready() -> void:
	scale_differnece = $shrinking_circle.scale.x - 0.2
	speed = scale_differnece / 1.1

func _physics_process(delta: float) -> void:
	if !hit:
		$shrinking_circle.scale -= Vector2(speed * delta, speed * delta)
		if $shrinking_circle.scale.x < 0.15:
			$Main_Sprite.visible = false
			$shrinking_circle.visible = false
			$Arrow.visible = false
			get_parent().reset_combo()
			hit = true
			

func _initialize(ran_input: int, order: int) -> void:
	if ran_input == 1:
		input = "Left"
		$Arrow.frame = 5
		$Main_Sprite.frame = 1
		$shrinking_circle.frame = 0
	elif ran_input == 2:
		input = "Up"
		$Arrow.frame = 4
		$Main_Sprite.frame = 3
		$shrinking_circle.frame = 2
	elif ran_input == 3:
		input = "Down"
		$Arrow.frame = 1
		$Main_Sprite.frame = 5
		$shrinking_circle.frame = 4
	elif ran_input == 4:
		input = "Right"
		$Arrow.frame = 0
		$Main_Sprite.frame = 7
		$shrinking_circle.frame = 6
	
	if order == 1:
		position = pos
		can_score = false
	elif order == 2:
		position = Vector2(pos.x + 220, pos.y)
		can_score = false
	elif order == 3:
		position = Vector2(pos.x + 440, pos.y)
		can_score = false
	elif order == 4:
		position = Vector2(pos.x + 660, pos.y)
		can_score = false
	elif order == 5:
		position = Vector2(randf_range(200, 1080), randf_range(150, 570))
		can_score = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action(input):
		if event.is_action_pressed(input):
			if $shrinking_circle.scale.x < 0.25 and $shrinking_circle.scale.x > 0.15:
				if can_score and !hit:
					get_parent().increment_score(3)
				_destroy()

func _destroy():
	$Main_Sprite.visible = false
	$shrinking_circle.visible = false
	$Arrow.visible = false
	hit = true

func _on_timer_timeout() -> void:
	queue_free()
