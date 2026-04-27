extends Control

const MAP_PATH = "res://map/map.tscn"

enum Player{HERO, MONSTER}
const MOVE_STR = ["Your move!", "Monster's move!"]
const END_STR = ["You won!", "You died."]
const MONSTER_THINKING_STR = "Monster is thinking..."

@onready var hero_name_label = $HeroStats/NameLabel
@onready var hero_hp_label = $HeroStats/HPLabel
@onready var hero_max_hp_label = $HeroStats/MaxHPLabel
@onready var monster_name_label = $MonsterStats/NameLabel
@onready var monster_hp_label = $MonsterStats/HPLabel
@onready var monster_max_hp_label = $MonsterStats/MaxHPLabel

@onready var move_label: Label = $MoveUI/MoveLabel
@onready var move_buttons_container: HBoxContainer = $MoveUI/MoveButtons
@onready var move_buttons : Array[Button] = [
	$MoveUI/MoveButtons/Button, 
	$MoveUI/MoveButtons/Button2, 
	$MoveUI/MoveButtons/Button3, 
	$MoveUI/MoveButtons/Button4
]

var turn: int = 0
var current_player: Player
var battle_over: bool = false
var hero: Fighter
var monster: Fighter

func _ready() -> void:
	hero = Fighter.from_hero(GameState.run_config["hero"])
	monster = Fighter.from_monster(GameState.current_encounter)
	turn = 1
	current_player = Player.HERO
	battle_over = false
	set_up_ui()


func _on_move_button_pressed(move_id: String) -> void:
	if battle_over or current_player != Player.HERO:
		return
	handle_hero_move(move_id)
		
		
func handle_hero_move(move_id: String) -> void:
	resolve_move(hero, monster, move_id)
	if not battle_over: 
		request_monster_move()
		refresh_ui()
		
		
func handle_monster_move(move_id: String) -> void:
	resolve_move(monster, hero, move_id)
	turn += 1
	if not battle_over: refresh_ui()
	
	
func request_monster_move() -> void:
	move_label.text = MONSTER_THINKING_STR
	
	var params = {
		"encounter_index": int(GameState.current_encounter["index"]),
		"monster_id": GameState.current_encounter["monster_id"],
		"monster_hp": monster.hp,
		"monster_max_hp": monster.max_hp,
		"hero_hp": hero.hp,
		"hero_max_hp": hero.max_hp,
		"turn_number": turn,
		"hero_effects": hero.effects.map(encode_effect),
		"monster_effects": monster.effects.map(encode_effect),
	}
	
	var response = await APIClient.get_monster_move(params)
	if response == null:
		current_player = Player.HERO
		refresh_ui()
		return
	
	handle_monster_move(response["move_id"])


func encode_effect(effect: Dictionary) -> String:
	return "%s:%d:%d" % [effect["stat"], effect["modifier"], effect["turns_remaining"]]
	
	
func resolve_move(attacker: Fighter, target: Fighter, move_id: String):
	var move = GameState.run_config["moves"][move_id]
	print("\n--- Turn %d: %s uses %s ---" % [turn, Player.keys()[current_player], move["name"]])
	
	var damage = Combat.compute_damage(move, attacker, target)
	target.take_damage(damage)
	print("%s HP: %d -> %d / %d" % [Player.keys()[1 - current_player], target.hp + damage, target.hp, target.max_hp])
	
	current_player = (current_player+1)%2
	
	if target.is_dead():
		end_battle()
	
func end_battle() -> void:
	battle_over = true
	refresh_ui()
	move_label.text = END_STR[(current_player+1)%2]


func set_up_ui() -> void:
	hero_name_label.text = hero.name
	hero_max_hp_label.text = str(hero.max_hp)
	monster_name_label.text = monster.name
	monster_max_hp_label.text = str(monster.max_hp)
	
	var moves = GameState.run_config["moves"]
	for i in range(hero.moves.size()):
		var move_id = hero.moves[i]
		move_buttons[i].text = moves[move_id]["name"]
		move_buttons[i].pressed.connect(_on_move_button_pressed.bind(move_id))
		
	refresh_ui()


func refresh_ui() -> void:
	hero_hp_label.text = str(hero.hp)
	monster_hp_label.text = str(monster.hp)
	
	if battle_over:
		move_buttons_container.visible = false
		return
	
	move_label.text = MOVE_STR[current_player]
	move_buttons_container.visible = (current_player == Player.HERO)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)
