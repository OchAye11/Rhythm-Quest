extends Area2D

const SPAWN_X: float = 640
const SPAWN_Y: float = 310

const UP_LANE_SPAWN: Vector2 = Vector2(651.37, SPAWN_Y)
const LEFT_LANE_SPAWN: Vector2 = Vector2(SPAWN_X, 360.0)
const RIGHT_LANE_SPAWN: Vector2 = Vector2(SPAWN_X, 353.0)
const DOWN_LANE_SPAWN: Vector2 = Vector2(650.37, SPAWN_Y)

var target_x: float
var target_y: float
var dist_to_target: float
var scale_difference: float

var move_speed: float = 0
var scale_speed: float = 0

var hit: bool = false
var dir: int = -1


func _on_ready() -> void:
	add_to_group("MovingRings")

func _physics_process(delta: float) -> void:
	if !hit:
		$Sprite2D.scale += Vector2(scale_speed * delta, scale_speed * delta)
		
		if dir == 0:
			position.y += move_speed * delta
			if position.y < 75:
				get_parent().reset_combo()
			if position.y < -100:
				queue_free()
		elif dir == 1:
			position.x += move_speed * delta
			if position.x > 940:
				get_parent().reset_combo()
			if position.x > 1360:
				queue_free()
		elif dir == 2:
			position.x += move_speed * delta
			if position.x < 350:
				get_parent().reset_combo()
			if position.x < -80:
				queue_free()
		elif dir == 3:
			position.y += move_speed * delta
			if position.y > 640:
				get_parent().reset_combo()
			if position.y > 780:
				queue_free()
	else:
		if dir == 1 or dir == 3:
			$LabelHolder.position.y += ((move_speed / 2) * delta) * -1
		else:
			$LabelHolder.position.y += (move_speed / 2) * delta

func _initialize(lane):
	dir = lane
	if lane == 0:
		position = UP_LANE_SPAWN
		target_y = 97.0
		dist_to_target = target_y - SPAWN_Y
		$Sprite2D.frame = 1
		$AnimationPlayer.play("Up_Ring_Moving")
	elif lane == 1:
		position = RIGHT_LANE_SPAWN
		target_x = 911.37
		dist_to_target = target_x - SPAWN_X
		$Sprite2D.frame = 3
		$AnimationPlayer.play("Right_Ring_Moving")
	elif lane == 2:
		position = LEFT_LANE_SPAWN
		target_x = 388.715
		dist_to_target = target_x - SPAWN_X
		$Sprite2D.frame = 0
		$AnimationPlayer.play("Left_Ring_Moving")
	elif lane == 3:
		position = DOWN_LANE_SPAWN
		target_y = 616.0
		dist_to_target = target_y - SPAWN_Y
		$Sprite2D.frame = 2
		$AnimationPlayer.play("Down_Ring_Moving")
	
	move_speed = dist_to_target / 1.7
	
	scale_difference = 1 - $Sprite2D.scale.x
	scale_speed = scale_difference / 1.7

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
		$LabelHolder/Label.text = "Okay"
		$LabelHolder/Label.modulate = Color("997577")

func _on_timer_timeout() -> void:
	queue_free()
