extends CanvasLayer

@export_file("*.json") var dialogue_file
@export var choices_layer: CanvasLayer

var dialogue: Dictionary
var current_dialogue_node: Dictionary
var next_dialogue_node: Dictionary
var dialogue_active: bool = false

var skipped: bool = false
var type_speed: float = 0.02

var sweat_talking: bool = false
var sour_talking: bool = false
var sweat_moved: bool = false
var sour_moved: bool = false
var sweat_location: float = 1013.0
var sour_location: float = 296.0
var sweat_start_location: float = 1567.0
var sour_start_location: float = -297.0
var speed: float = 10

func _on_ready() -> void:
	$NameBox.visible = false
	$TextBox.visible = false
	$CharacterHolder.visible = false
	
func start() -> void:
	if dialogue_active:
		return
	dialogue_active = true
	get_parent().dialogue_finished = false
	$NameBox.visible = true
	$TextBox.visible = true
	$CharacterHolder.visible = true
	sweat_talking = false
	sour_talking = false
	dialogue = load_dialogue()
	current_dialogue_node = dialogue["00"]
	next_text(current_dialogue_node)
	
func _physics_process(delta):
	if sweat_talking and $CharacterHolder/Sweat.position.x > sweat_location + 5:
		$CharacterHolder/Sweat.position.x = lerp($CharacterHolder/Sweat.position.x, sweat_location, speed * delta)
	if sour_talking and $CharacterHolder/Sour.position.x < sour_location - 5:
		$CharacterHolder/Sour.position.x = lerp($CharacterHolder/Sour.position.x, sour_location, speed * delta)
	
func _input(event: InputEvent) -> void:
	if !dialogue_active:
		return
	if event.is_action_pressed("Accept") and !get_parent().is_paused:
		if !skipped:
			skipped = true
			$TextBox/Text.visible_characters = -1
		else:
			current_dialogue_node = next_dialogue_node
			next_text(current_dialogue_node)

	
func load_dialogue():
	if FileAccess.file_exists(dialogue_file):
		var file = FileAccess.get_file_as_string(dialogue_file)
		var json_file = JSON.parse_string(file)
		
		return json_file

func next_text(node: Dictionary) -> void:
	if node.has("trigger"):
		if node["trigger"] == "end":
			$NameBox.visible = false
			$TextBox.visible = false
			$CharacterHolder.visible = false
			$CharacterHolder/Sour.position.x = sour_start_location
			$CharacterHolder/Sweat.position.x = sweat_start_location
			dialogue_active = false

			get_parent().dialogue_is_finished()
			get_tree().paused = false
			return
	
	if node.has("condition"):
		if node["condition"] is Dictionary:
			var key_node = node["condition"].keys()
			if key_node.size() == 2:
				if !Global.get(key_node[0]) or !Global.get(key_node[1]):
					var failed_key = node["condition_failed"]
					next_text(dialogue[failed_key])
					return
			elif key_node.size() == 3:
				if !Global.get(key_node[0]) or !Global.get(key_node[1]) or !Global.get(key_node[2]):
					var failed_key = node["condition_failed"]
					next_text(dialogue[failed_key])
					return
			elif key_node.size() == 4:
				if !Global.get(key_node[0]) or !Global.get(key_node[1]) or !Global.get(key_node[2]) or !Global.get(key_node[3]):
					var failed_key = node["condition_failed"]
					next_text(dialogue[failed_key])
					return
			elif key_node.size() == 5:
				if !Global.get(key_node[0]) or !Global.get(key_node[1]) or !Global.get(key_node[2]) or !Global.get(key_node[3]) or !Global.get(key_node[4]):
					var failed_key = node["condition_failed"]
					next_text(dialogue[failed_key])
					return
		else:
			if !Global.get(node["condition"]):
					var failed_key = node["condition_failed"]
					next_text(dialogue[failed_key])
					return
	
	if node.has("change_condition"):
		if !Global.get(node["change_condition"]):
			Global.set(node["change_condition"], true)
		else:
			Global.set(node["change_condition"], false)
	
	if node.has("effect"):
		match node["effect"]:
			"light":
				get_parent().light_effect()
			"arrow_appear":
				get_parent().arrow_appear()
			"arrow_disappear":
				get_parent().arrow_disappear()
			"axe_appear":
				get_parent().axe_appear()
			"enemy_appear":
				get_parent().enemy_appear()
			"lost_riddle":
				get_parent().lost_riddle()
			"reward":
				get_parent().show_reward()
			"chest":
				get_parent().show_chest()
			"paper":
				get_parent().show_paper()
			"dissapear":
				$CharacterHolder/Sour.visible = false
				$CharacterHolder/Sweat.visible = false
	
	if node.has("name"):
		match node["name"]:
			"Sweat":
				sweat_talking = true
			"Sour":
				sour_talking = true
	
	if node.has("choices"):
		choices_layer.visible = true
		choices_layer.set_choices(node["choices"])
		if !choices_layer.is_connected("choice_made", _choice_made):
			choices_layer.choice_made.connect(_choice_made)
	
	if node.has("emotion"):
		change_emotion(node["emotion"], node["name"])
	
	if node.has("text"):
		$TextBox/Text.visible_characters = 0
		skipped = false
	
	if node.has("next") and node.has("text"):
		$NameBox/Name.text = node["name"]
		$TextBox/Text.text = node["text"]
	
	if node.has("next"):
		var key = node["next"]
		next_dialogue_node = dialogue[key]
	
	next_char()

func next_char():
	var text_length = $TextBox/Text.text.length()
	for i in text_length:
		if skipped:
			break
		$TextBox/Text.visible_characters = i + 1
		await get_tree().create_timer(type_speed).timeout
	skipped = true

func change_emotion(emotion: String, character: String):
	var row: int = 1
	var sprite
	
	if character != "Lumberjack":
		if character != "Narrator":
			if character != "??????":
				if character != "Choc'lat":
					if character != "Sweat and Sour":
						if character != "Lord Burger":
							if character != "Stone Golem":
								if character != "Lord Pasta":
									sprite = get_node("CharacterHolder/" + character)
		
	match character:
		"Sweat": 
			row = 0
		"Sour": 
			row = 6
	
	match emotion:
		"normal": 
			sprite.frame = 0 + row
		"happy": 
			sprite.frame = 1 + row
		"indifferent": 
			sprite.frame = 2 + row
		"confused": 
			sprite.frame = 3 + row
		"angry": 
			sprite.frame = 4 + row
		"talking": 
			match character:
				"Sweat": 
					sprite.frame = 5 + row
					$CharacterHolder/Sour.frame = 6
				"Sour": 
					sprite.frame = 5 + row
					$CharacterHolder/Sweat.frame = 0
				"Lumberjack":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"Narrator":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"??????":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"Choc'lat":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"Lord Burger":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"Sweat and Sour":
					$CharacterHolder/Sweat.frame =  5
					$CharacterHolder/Sour.frame =  11
				"Stone Golem":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6
				"Lord Pasta":
					$CharacterHolder/Sweat.frame = 0
					$CharacterHolder/Sour.frame = 6

func _choice_made(next_node: String):
	next_dialogue_node = dialogue[next_node]
	next_text(next_dialogue_node)
	choices_layer.visible = false
