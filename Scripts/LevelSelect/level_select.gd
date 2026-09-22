extends Node2D

var moving: bool = false
var direction: String = ""
var speed: float = 270
var up_location: float = 720
var down_location: float = 0

var dialogue_finished: bool = false
var is_paused: bool = false

func _ready() -> void:
	$Fade_Trans.show()
	$Fade_Trans/AnimationPlayer.play("fade_out")
	$Fade_Trans/Timer.start()
	
	if Global.can_talk:
		$DialoguePlayer.dialogue_file = Global.next_dialogue
		$DialoguePlayer.start()
		
		get_tree().paused = true


func _on_timer_timeout() -> void:
	$Fade_Trans.hide()

func _physics_process(delta: float) -> void:
	if moving:
		if direction == "up":
			$Container.position.y = move_toward($Container.position.y, up_location, speed * delta)
		elif direction == "down":
			$Container.position.y = move_toward($Container.position.y, down_location, speed * delta)
	
	if $Container.position.y == up_location:
		$ScrollArrowUp.frame = 2
		$ScrollArrowUp.scale = Vector2(0.4, 0.4)
	elif moving and direction == "up":
		$ScrollArrowUp.frame = 1
	else:
		$ScrollArrowUp.frame = 0
	
	if $Container.position.y == down_location:
		$ScrollArrowDown.frame = 2
		$ScrollArrowDown.scale = Vector2(0.4, 0.4)
	elif moving and direction == "down":
		$ScrollArrowDown.frame = 1
	else:
		$ScrollArrowDown.frame = 0

func dialogue_is_finished():
	dialogue_finished = true
