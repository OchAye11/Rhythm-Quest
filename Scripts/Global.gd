extends Node

var test_var: bool = false

var Test: bool = true

var next_dialogue = "res://Dialogue/level_select_1.json"

var can_talk: bool = false

var level_1: bool = true

var level2_1: bool = false

var level2_2: bool = false

var level_3: bool = false

var level4_1: bool = false

var level4_2: bool = false

var level_5: bool = false

var level6_1: bool = false

var level6_2: bool = false

var level_7: bool = false


var sweat_choices: int = 0

var sour_choices: int = 0

var total_score: int = 0

var highest_combo: int = 0

var dropped_axe: bool = false

var killed_tree: bool = false

var has_gold: bool = false

var tree_cut_1: bool = false

var been_lost_1: bool = false

var been_lost_2: bool = false

var choice_4_2: bool = false

var fight_5: bool = false

var lord_killed: bool = false

var riddle_5: bool = false
var won_riddle_5: bool = true
var lost_riddle_5: bool = false

var been_lost_3: bool = false

var choice_6_1: bool = false
var tree_cut_2: bool = false
var magic_used: bool = false

var killed_sweat: bool = false
var killed_sour: bool = false
var killed_golem: bool = false
var entered_password: bool = false
var entered_password_wrong: bool = false

var big_prize: bool = false
var medium_prize: bool = false
var small_prize: bool = false

var finished_game: bool = false

func check_combo(value: int):
	if value > highest_combo:
		highest_combo = value

func reset():
	test_var = false
	
	Test = true
	
	next_dialogue = "res://Dialogue/level_select_1.json"
	
	can_talk = false
	
	level_1 = true
	
	level2_1 = false
	
	level2_2 = false
	
	level_3 = false
	
	level4_1 = false
	
	level4_2 = false
	
	level_5 = false
	
	level6_1 = false
	
	level6_2 = false
	
	level_7 = false
	
	sweat_choices = 0
	
	sour_choices = 0
	
	total_score = 0
	
	highest_combo = 0
	
	dropped_axe = false
	
	killed_tree = false
	
	has_gold = false
	
	tree_cut_1 = false
	
	been_lost_1 = false
	
	been_lost_2 = false
	
	choice_4_2 = false
	
	fight_5 = false
	
	lord_killed = false
	
	riddle_5 = false
	won_riddle_5 = true
	lost_riddle_5 = false
	
	been_lost_3 = true
	
	choice_6_1 = false
	tree_cut_2 = false
	magic_used = false
	
	killed_sweat = false
	killed_sour = false
	killed_golem = false
	entered_password = false
	entered_password_wrong = false
	
	big_prize = false
	medium_prize = false
	small_prize = false
	
	finished_game = false
