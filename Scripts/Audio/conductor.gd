extends AudioStreamPlayer

var bpm: float = 100
var measures: int = 4

var song_position: float = 0.0
var song_position_in_beats: int = 1
var seconds_per_beat: float = 60 / bpm
var last_reported_beat: int = 0
var beats_before_start: int = 0
var measure: int = 1

var closest: int = 0
var time_off_beat: float = 0.0

signal beat(position)
signal measured(position)

func _ready():
	seconds_per_beat = 60.0 / bpm

func _physics_process(_delta):
	if playing:
		song_position = get_playback_position() + AudioServer.get_time_since_last_mix()
		song_position -= AudioServer.get_output_latency()
		song_position_in_beats = int(floor(song_position / seconds_per_beat)) + beats_before_start
		_report_beat()

func _report_beat():
	if last_reported_beat < song_position_in_beats:
		if measure > measures:
			measure = 1
		emit_signal("beat", song_position_in_beats)
		emit_signal("measured", measure)
		last_reported_beat = song_position_in_beats
		measure += 1

func play_with_beat_offset(num):
	beats_before_start = num
	$StartTimer.wait_time = seconds_per_beat
	$StartTimer.start()


func closest_beat(nth):
	closest = int(round((song_position / seconds_per_beat) / nth) * nth) 
	time_off_beat = abs(closest * seconds_per_beat - song_position)
	return Vector2(closest, time_off_beat)


func play_from_beat(beat_pos, offset):
	play()
	seek(beat_pos * seconds_per_beat)
	beats_before_start = offset
	measure = beat_pos % measures

func _on_start_timer_timeout() -> void:
	song_position_in_beats += 1
	if song_position_in_beats < beats_before_start - 1:
		$StartTimer.start()
	elif song_position_in_beats == beats_before_start - 1:
		$StartTimer.wait_time = $StartTimer.wait_time - (AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency())
		$StartTimer.start()
	else:
		play()
		$StartTimer.stop()
	_report_beat()
