extends Node2D

var score: int = 0
var combo: int = 0

var poor_score: int = 300
var good_score: int = 900
var great_score: int = 1200

var max_combo: int = 0

var song_ended: bool = false

var song_position_in_beats: int = 0

var spawn_1_beat: int = 0
var spawn_2_beat: int = 0
var spawn_3_beat: int = 1
var spawn_4_beat: int = 1

var rand: int = 0
var circle_num: int
var circle = load("res://Objects/Game/osu_circles.tscn")
var instance

var dialogue_finished: bool = false
var is_paused: bool = false


func _on_ready() -> void:
	randomize()
	$Conductor.play_with_beat_offset(6)
	#$Conductor.play_from_beat(128, 5)
	
	Global.sweat_choices += 1
	
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
	if song_position_in_beats > 12:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 36:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 0
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 110:
		spawn_1_beat = 1
		spawn_2_beat = 1
		spawn_3_beat = 1
		spawn_4_beat = 1
	if song_position_in_beats > 114:
		spawn_1_beat = 0
		spawn_2_beat = 0
		spawn_3_beat = 0
		spawn_4_beat = 0
	if song_position_in_beats == 117:
		if !song_ended:
			song_ended = true
			$TimerContainer/DialogueTimer.start()
			$TimerContainer/EndTimer.start()

func _spawn_notes(to_spawn: int):
	if to_spawn > 0:
		circle_num = randi() % 4 + 1
		instance = circle.instantiate()
		instance._initialize(circle_num, 5)
		add_child(instance)
	if to_spawn > 1:
		rand = randi() % 4
		while rand == circle_num:
			rand = randi() % 4
		circle_num = rand
		instance = circle.instantiate()
		instance._initialize(circle_num, 5)
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

func _on_end_timer_timeout() -> void:
	$Scoreboard.start()
	Global.level2_1 = false
	Global.level2_2 = false
	Global.level_3 = true
	Global.next_dialogue = "res://Dialogue/level_select_2_2.json"
	Global.can_talk = true
	Global.tree_cut_1 = true

func _on_dialogue_timer_timeout() -> void:
	$DialoguePlayer.dialogue_file = "res://Dialogue/level_2_2_end.json"
	$DialoguePlayer.start()
	get_tree().paused = true

func dialogue_is_finished():
	dialogue_finished = true
