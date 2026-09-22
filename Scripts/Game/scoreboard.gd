extends CanvasLayer

var start_fade: bool = false
var target_score: int = 0
var target_combo: int = 0

var current_score: int = 0
var current_combo: int = 0

var speed: float = 0.7
var lerp_speed: float = 3.0

var start_good: bool = false
var start_great: bool = false
var finished_great: bool = false

var target_overscale: float = 1.0
var target_scale: float = 0.9

func start():
	visible = true
	target_score = get_parent().score
	target_combo = get_parent().max_combo
	
	Global.total_score += target_score
	Global.check_combo(target_combo)
	
	var score_tween = get_tree().create_tween()
	var combo_tween = get_tree().create_tween()
	
	score_tween.tween_method(count_score, 0, get_parent().score, 3.5)
	combo_tween.tween_method(count_combo, 0, get_parent().max_combo, 3.5)

func _physics_process(delta: float) -> void:
	if target_score >= get_parent().poor_score and !start_good:
		$"StarContainer/PoorStar".scale.x = move_toward($"StarContainer/PoorStar".scale.x, target_overscale, speed * delta)
		$"StarContainer/PoorStar".scale.y = move_toward($"StarContainer/PoorStar".scale.y, target_overscale, speed * delta)
	
	if $"StarContainer/PoorStar".scale.x == target_overscale:
		start_good = true
	
	if start_good:
		$"StarContainer/PoorStar".scale.x = lerp($"StarContainer/PoorStar".scale.x, target_scale, lerp_speed * delta)
		$"StarContainer/PoorStar".scale.y = lerp($"StarContainer/PoorStar".scale.y, target_scale, lerp_speed * delta)
	
	if target_score >= get_parent().good_score and !start_great and start_good:
		$StarContainer/GoodStar.scale.x = move_toward($"StarContainer/GoodStar".scale.x, target_overscale, speed * delta)
		$"StarContainer/GoodStar".scale.y = move_toward($"StarContainer/GoodStar".scale.y, target_overscale, speed * delta)
	
	if $"StarContainer/GoodStar".scale.x == target_overscale:
		start_great = true
	
	if start_great:
		$StarContainer/GoodStar.scale.x = lerp($"StarContainer/GoodStar".scale.x, target_scale, lerp_speed * delta)
		$"StarContainer/GoodStar".scale.y = lerp($"StarContainer/GoodStar".scale.y, target_scale, lerp_speed * delta)
	
	if target_score >= get_parent().great_score and !finished_great and start_great:
		$StarContainer/GreatStar.scale.x = move_toward($"StarContainer/GreatStar".scale.x, target_overscale, speed * delta)
		$"StarContainer/GreatStar".scale.y = move_toward($"StarContainer/GreatStar".scale.y, target_overscale, speed * delta)
	
	if $"StarContainer/GreatStar".scale.x == target_overscale:
		finished_great = true
	
	if finished_great:
		$StarContainer/GreatStar.scale.x = lerp($"StarContainer/GreatStar".scale.x, target_scale, lerp_speed * delta)
		$"StarContainer/GreatStar".scale.y = lerp($"StarContainer/GreatStar".scale.y, target_scale, lerp_speed * delta)
	
	if start_fade:
		$Fade_Trans.show()
		$Fade_Trans/FadeTimer.start()
		$Fade_Trans/AnimationPlayer.play("fade_in")
		start_fade = false

func count_score(value: float):
	current_score = int(value)
	$TextContainer/Score.text = "Score: " + str(current_score)

func count_combo(value: float):
	current_combo = int(value)
	$TextContainer/MaxCombo.text = "Max Combo: " + str(current_combo)

func _on_fade_timer_timeout() -> void:
	if !Global.finished_game:
		get_tree().change_scene_to_file("res://Levels/LevelSelect.tscn")
	else:
		get_tree().change_scene_to_file("res://Levels/EndScene.tscn")
