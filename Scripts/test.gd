extends Node2D

var score: int = 0
var combo: int = 0

var poor_score: int = 300
var good_score: int = 700
var great_score: int = 1000

var max_combo: int = 0
var great: int = 0
var good: int = 0
var okay: int = 0
var missed: int = 0

var song_ended: bool = false

var bpm: int = 100

var song_position: float = 0.0
var song_position_in_beats: int = 0
var last_spawned_beat: int = 0
var sec_per_beat: float = 60.0 / bpm

var spawn_1_beat: int = 0
var spawn_2_beat: int = 0
var spawn_3_beat: int = 1
var spawn_4_beat: int = 0

var lane: int = 0
var rand: int = 0
var note = load("res://Objects/Game/falling_arrows.tscn")
var circle = load("res://Objects/Game/osu_circles.tscn")
var instance

var current_negation: String = "Range"
var damage_type: String = "Range"

var circle_num: int
var circle_chosen: Array[int] = []

var mellee_negation
var range_negation

var dialogue_finished: bool = false
var is_paused: bool = false

func _ready():
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
	if song_position_in_beats > 31:
		$EnemyDamage.visible = false
	if song_position_in_beats > 32:
		$EnemyDamage.visible = true
	if song_position_in_beats > 33:
		$EnemyDamage.visible = false
	if song_position_in_beats > 34:
		$EnemyDamage.visible = true
	if song_position_in_beats > 35:
		$EnemyDamage.visible = false
	if song_position_in_beats > 36:
		$EnemyDamage.visible = true
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
		damage_type = "Mellee"
		$EnemyDamage.frame = 2
	if song_position_in_beats > 40:
		$EnemyDamage.visible = false
	if song_position_in_beats > 41:
		$EnemyDamage.visible = true
	if song_position_in_beats > 42:
		$EnemyDamage.visible = false
	if song_position_in_beats > 43:
		$EnemyDamage.visible = true
	if song_position_in_beats > 44:
		$EnemyDamage.visible = false
	if song_position_in_beats > 45:
		$EnemyDamage.visible = true
		damage_type = "Range"
		$EnemyDamage.frame = 3
	if song_position_in_beats > 98:
		spawn_1_beat = 2
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 123:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats == 126:
		$DialogueTimer.start()
	if song_position_in_beats > 127:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 131:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats == 133:
		if !song_ended:
			song_ended = true
			$EndTimer.start()
	if song_position_in_beats > 194:
		spawn_1_beat = 2
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 228:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 258:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 2
	if song_position_in_beats > 288:
		spawn_1_beat = 0
		spawn_2_beat = 2
		spawn_3_beat = 0
		spawn_4_beat = 2
	if song_position_in_beats > 322:
		spawn_1_beat = 3
		spawn_2_beat = 2
		spawn_3_beat = 2
		spawn_4_beat = 1
	if song_position_in_beats > 388:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats > 396:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0

func _spawn_notes(to_spawn):
	if song_position_in_beats < 128:
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
	
	if by == 3:
		great += 1
	elif by == 2:
		good += 1
	elif by == 1:
		okay += 1
	else:
		missed += 1
	
	
	score += by * combo
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
	Global.level_3 = false
	Global.level4_1 = false
	Global.level4_2 = false
	Global.can_talk = true


func _on_dialogue_timer_timeout() -> void:
	$DialoguePlayer.dialogue_file = "res://Dialogue/test2.json"
	$DialoguePlayer.start()
	get_tree().paused = true
