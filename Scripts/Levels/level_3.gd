extends Node2D

var score: int = 0
var combo: int = 0

var poor_score: int = 500
var good_score: int = 1000
var great_score: int = 1500

var max_combo: int = 0

var song_ended: bool = false

var song_position_in_beats: int = 0

var spawn_1_beat: int = 0
var spawn_2_beat: int = 0
var spawn_3_beat: int = 1
var spawn_4_beat: int = 1

var lane: int = 0
var rand: int = 0
var note = load("res://Objects/Game/falling_arrows.tscn")
var circle = load("res://Objects/Game/osu_circles.tscn")
var instance

var dialogue_finished: bool = false
var is_paused: bool = false

var current_negation: String = "Range"
var damage_type: String = "Range"

var circle_num: int
var circle_chosen: Array[int] = []

var mellee_negation
var range_negation

func _on_ready() -> void:
	randomize()
	$Conductor.play_with_beat_offset(6)
	#$Conductor.play_from_beat(128, 5)
	mellee_negation = $Mellee_Negation_Icon
	range_negation = $Range_Negation_Icon
	
	range_negation.frame = 4
	
	get_tree().paused = true
	$DialoguePlayer.start()

func _on_conductor_measured(beat_position: Variant) -> void:
	if beat_position == 1:
		_spawn_notes(spawn_1_beat)
	elif beat_position == 2:
		_spawn_notes(spawn_2_beat)
	elif beat_position == 3:
		_spawn_notes(spawn_3_beat)
	elif beat_position == 4:
		_spawn_notes(spawn_4_beat)

func _on_conductor_beat(position_of_song: Variant) -> void:
	song_position_in_beats = position_of_song
	print(song_position_in_beats)
	
	if song_position_in_beats == 4:
		if Global.dropped_axe:
			Global.next_dialogue = "res://Dialogue/level_select_3.json"
			Global.level_3 = false
			Global.level4_1 = true
			Global.level4_2 = true
			Global.can_talk = true
			Global.sweat_choices += 1
			get_tree().change_scene_to_file("res://Levels/LevelSelect.tscn")
	if song_position_in_beats > 36:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 55:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 90:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 91:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 92:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 93:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 94:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 95:
		$Environment/EnemyDamage.visible = true
		damage_type = "Mellee"
		$Environment/EnemyDamage.frame = 5
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 120:
		spawn_1_beat = 2
		spawn_2_beat = 1
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 154:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats == 158:
		$Timers/DialogueTimer.start()
	if song_position_in_beats > 159:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 163:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats == 165:
		if !song_ended:
			song_ended = true
			destroy_tree()
			$Timers/EndTimer.start()

func _spawn_notes(to_spawn):
	if song_position_in_beats < 160:
		if to_spawn > 0:
			lane = randi() % 4
			instance = note.instantiate()
			instance._initialize(lane)
			add_child(instance)
		if to_spawn > 1:
			while rand == lane:
				rand = randi() % 4
			lane = rand
			instance = note.instantiate()
			instance._initialize(lane)
			add_child(instance)
	else:
		if to_spawn > 0:
			circle_num = randi() % 4 + 1
			while circle_chosen.has(circle_num):
				circle_num = randi() % 4 + 1
			circle_chosen.append(circle_num)
			instance = circle.instantiate()
			instance._initialize(circle_num, circle_chosen.size())
			add_child(instance)

func increment_score(by):
	if by > 0:
		combo += 1
	else:
		combo = 0
	
	if combo < 11:
		score += by * combo
	else:
		score += by * 10 
	$LabelHolder/Score.text = "Score: " + str(score)
	if combo > 0:
		$LabelHolder/Combo.text = str(combo) + " combo!"
		if combo > max_combo:
			max_combo = combo
	else:
		$LabelHolder/Combo.text = ""

func reset_combo():
	combo = 0
	$LabelHolder/Combo.text = ""

func _on_range_negation_icon_negation_pressed(type: Variant) -> void:
	if current_negation == type:
		pass
	else:
		current_negation = type
		range_negation.frame = 4
		mellee_negation.frame = 2

func _on_mellee_negation_icon_negation_pressed(type: Variant) -> void:
	if current_negation == type:
		pass
	else:
		current_negation = type
		range_negation.frame = 1
		mellee_negation.frame = 5

func _on_end_timer_timeout() -> void:
	$Scoreboard.start()
	Global.next_dialogue = "res://Dialogue/level_select_3.json"
	Global.level_3 = false
	Global.level4_1 = true
	Global.level4_2 = true
	Global.can_talk = true
	Global.sour_choices += 1

func _on_dialogue_timer_timeout() -> void:
	$DialoguePlayer.dialogue_file = "res://Dialogue/level_3_end.json"
	$DialoguePlayer.start()
	get_tree().paused = true

func dialogue_is_finished():
	dialogue_finished = true

func light_effect():
	$ColorRect/AnimationPlayer.play("Light_Up")
	$Timers/AxeTimer.start()

func arrow_appear():
	$Environment/PointingArrow.visible = true

func arrow_disappear():
	$Environment/PointingArrow.visible = false

func axe_appear():
	$Environment/Axe.visible = true


func _on_axe_timer_timeout() -> void:
	$Environment/Axe.visible = false

func destroy_tree():
	var tween: Tween = create_tween()
	var tween2: Tween = create_tween()
	tween.tween_property($Environment/TreeLeaves, "modulate:v", 100, 1).from(1)
	tween2.tween_property($Environment/TreeBranch, "modulate:v", 100, 1).from(1)
	$Timers/DestroyTimer.start()

func _on_destroy_timer_timeout() -> void:
	$Environment/TreeLeaves.visible = false
	$Environment/TreeBranch.visible = false
	$Environment/EnemyDamage.visible = false
