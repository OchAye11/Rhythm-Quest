extends Area2D

const TARGET_Y: float = 474.0 + 64
const SPAWN_Y: float = -85
const DIST_TO_TARGET: float = TARGET_Y - SPAWN_Y

const LEFT_LANE_SPAWN: Vector2 = Vector2(321.8, SPAWN_Y)
const UP_LANE_SPAWN: Vector2 = Vector2(505.8, SPAWN_Y)
const DOWN_LANE_SPAWN: Vector2 = Vector2(707.9, SPAWN_Y)
const RIGHT_LANE_SPAWN: Vector2 = Vector2(923.8, SPAWN_Y)

var speed: float = 0
var hit: bool = false

func _ready() -> void:
	add_to_group("FallingArrow")

func _physics_process(delta):
	if !hit:
		position.y += speed * delta
		if position.y > 712:
			queue_free()
			get_parent().reset_combo()
	else:
		$LabelHolder.position.y -= speed * delta

func _initialize(lane):
	if lane == 0:
		$Sprite2D.frame = 11
		position = LEFT_LANE_SPAWN
	elif lane == 1:
		$Sprite2D.frame = 9
		position = UP_LANE_SPAWN
	elif lane == 2:
		$Sprite2D.frame = 10
		position = DOWN_LANE_SPAWN
	elif lane == 3:
		$Sprite2D.frame = 8
		position = RIGHT_LANE_SPAWN
	else:
		printerr("Invalid lane set for note: " + str(lane))
		return
	
	speed = DIST_TO_TARGET / 1.1


func _destroy(score):
	$Sprite2D.visible = false
	$CollisionShape2D.disabled = true
	$Timer.start()
	hit = true
	if score == 3:
		$LabelHolder/Label.text = "Perfect"
		$LabelHolder/Label.modulate = Color("f6d6bd")
	elif score == 2:
		$LabelHolder/Label.text = "GOOD"
		$LabelHolder/Label.modulate = Color("c3a38a")
	elif score == 1:
		$LabelHolder/Label.text = "OKAY"
		$LabelHolder/Label.modulate = Color("997577")

func _on_timer_timeout() -> void:
	queue_free()
