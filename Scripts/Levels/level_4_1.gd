extends Node2D

var score: int = 0
var combo: int = 0

var poor_score: int = 600
var good_score: int = 1100
var great_score: int = 1400

var max_combo: int = 0

var song_ended: bool = false

var song_position_in_beats: int = 0

var spawn_1_beat: int = 0
var spawn_2_beat: int = 0
var spawn_3_beat: int = 1
var spawn_4_beat: int = 0

var lane: int = 0
var rand: int = 0
var square = load("res://Objects/Game/moving_square.tscn")
var instance

var dialogue_finished: bool = false
var is_paused: bool = false

func _on_ready() -> void:
	randomize()
	$Conductor.play_with_beat_offset(7)
	#$Conductor.play_from_beat(128, 5)
	
	Global.sour_choices += 1
	
	$square_icon_sweat.color = "#34c039"
	$square_icon_sweat/ColorRect.color = "#6bfd71"
	$square_icon.color = "#54e3fa"
	$square_icon/ColorRect.color = "#96f0ff"
	
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
		spawn_2_beat = 1
		spawn_3_beat = 0
		spawn_4_beat = 1
	if song_position_in_beats > 98:
		spawn_1_beat = 1
		spawn_2_beat = 2
		spawn_3_beat = 1
		spawn_4_beat = 0
	if song_position_in_beats > 112:
		spawn_1_beat = 1
		spawn_2_beat = 0
		spawn_3_beat = 2
		spawn_4_beat = 1
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
	if song_position_in_beats == 134:
		if !song_ended:
			song_ended = true
			$TimerContainer/EndTimer.start()

func _spawn_notes(to_spawn: int):
	if to_spawn > 0:
		lane = randi() % 3
		instance = square.instantiate()
		instance._initialize(lane)
		add_child(instance)
	if to_spawn > 1:
		while rand == lane:
			rand = randi() % 3
		lane = rand
		instance = square.instantiate()
		instance._initialize(lane)
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
	Global.level4_1 = false
	Global.level4_2 = false
	Global.level_5 = true
	Global.next_dialogue = "res://Dialogue/level_select_4_1.json"
	Global.been_lost_2 = true
	Global.can_talk = true

func dialogue_is_finished():
	dialogue_finished = true
