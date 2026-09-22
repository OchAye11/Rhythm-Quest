extends Node2D

var score: int = 0
var combo: int = 0

var poor_score: int = 600
var good_score: int = 1100
var great_score: int = 1600

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
var magic_negation

func _on_ready() -> void:
	randomize()
	$Conductor.play_with_beat_offset(6)
	#$Conductor.play_from_beat(128, 5)
	mellee_negation = $Mellee_Damage_Negation_Icon
	range_negation = $Range_Damage_Negation_Icon2
	magic_negation = $Magic_Damage_Negation_Icon3
	
	range_negation.frame = 4
	
	$Environment/Enemy.visible = false
	$Environment/EnemyDamage.visible = false
	
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
		if Global.riddle_5 and Global.won_riddle_5:
			Global.next_dialogue = "res://Dialogue/level_select_5.json"
			Global.level_5 = false
			Global.level6_1 = true
			Global.level6_2 = true
			Global.can_talk = true
			Global.sweat_choices += 1
			get_tree().change_scene_to_file("res://Levels/LevelSelect.tscn")
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 55:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 56:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 57:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 58:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 59:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 60:
		$Environment/EnemyDamage.visible = true
		damage_type = "Mellee"
		$Environment/EnemyDamage.frame = 5
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 2
		spawn_4_beat = 0
	if song_position_in_beats > 99:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 100:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 101:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 102:
		$Environment/EnemyDamage.visible = true
	if song_position_in_beats > 103:
		$Environment/EnemyDamage.visible = false
	if song_position_in_beats > 104:
		$Environment/EnemyDamage.visible = true
		damage_type = "Magic"
		$Environment/EnemyDamage.frame = 3
	
	if song_position_in_beats > 120:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
		
	if song_position_in_beats > 154:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
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
			destroy_enemy()
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

func _on_mellee_damage_negation_icon_negation_pressed(type: Variant) -> void:
	if current_negation == type:
		pass
	else:
		current_negation = type
		range_negation.frame = 1
		mellee_negation.frame = 5
		magic_negation.frame = 0

func _on_range_damage_negation_icon_2_negation_pressed(type: Variant) -> void:
	if current_negation == type:
		pass
	else:
		current_negation = type
		range_negation.frame = 4
		mellee_negation.frame = 2
		magic_negation.frame = 0

func _on_magic_damage_negation_icon_3_negation_pressed(type: Variant) -> void:
	if current_negation == type:
		pass
	else:
		current_negation = type
		range_negation.frame = 1
		mellee_negation.frame = 2
		magic_negation.frame = 3

func dialogue_is_finished():
	dialogue_finished = true

func destroy_enemy():
	var tween: Tween = create_tween()
	tween.tween_property($Environment/Enemy, "modulate:v", 10, 1).from(1)
	$Timers/DestroyTimer.start()

func _on_destroy_timer_timeout() -> void:
	$Environment/Enemy.visible = false
	$Environment/EnemyDamage.visible = false

func _on_end_timer_timeout() -> void:
	$Scoreboard.start()
	Global.next_dialogue = "res://Dialogue/level_select_5.json"
	Global.level_5 = false
	Global.level6_1 = true
	Global.level6_2 = true
	Global.lord_killed = true
	Global.can_talk = true
	Global.sour_choices += 1

func enemy_appear():
	$Environment/Enemy.visible = true
	$Environment/EnemyDamage.visible = true

func lost_riddle():
	Global.won_riddle_5 = false
	Global.lost_riddle_5 = true
