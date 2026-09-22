extends Area2D

const TARGET_X: float = 226.0
const SPAWN_X: float = 1327.0
const DIST_TO_TARGET: float = TARGET_X - SPAWN_X

const UP_LANE_SPAWN: Vector2 = Vector2(SPAWN_X, 140.985)
const MIDDLE_LANE_SPAWN: Vector2 = Vector2(SPAWN_X, 320.615)
const DOWN_LANE_SPAWN: Vector2 = Vector2(SPAWN_X, 505.395)

var speed: float = 0
var hit: bool = false


func _on_ready() -> void:
	add_to_group("MovingSquare")

func _physics_process(delta):
	if !hit:
		position.x += speed * delta
		if position.x < 200:
			get_parent().reset_combo()
		if position.x < -40:
			queue_free()
	else:
		$LabelHolder.position.y += (speed / 2) * delta

func _initialize(lane):
	if lane == 0:
		position = UP_LANE_SPAWN
		$ColorRect.color = "ff625f"
	elif lane == 1:
		position = MIDDLE_LANE_SPAWN
		$ColorRect.color = "#96f0ff"
	elif lane == 2:
		position = DOWN_LANE_SPAWN
		$ColorRect.color = "#6bfd71"
	
	speed = DIST_TO_TARGET / 1.7

func _destroy(score):
	$ColorRect.visible = false
	$CollisionShape2D.disabled = true
	$Timer.start()
	hit = true
	if score == 3:
		$LabelHolder/Label.text = "Perfect"
		$LabelHolder/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$LabelHolder/Label.text = "GOOD"
		$LabelHolder/Label.modulate = Color("c3a38a")

func _on_timer_timeout() -> void:
	queue_free()
