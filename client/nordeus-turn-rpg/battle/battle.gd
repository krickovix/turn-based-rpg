extends Control

const MAP_PATH = "res://map/map.tscn"

enum Player{HERO, MONSTER}
const MOVE_STR = ["Your move!", "Monster's move!"]
const END_STR = ["You won!", "You died."]
const MONSTER_THINKING_STR = "Monster is thinking..."

@onready var back_button: Button = $BackButton

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
	hero = RunState.hero
	monster = RunState.monsters[RunState.current_encounter_index]
	turn = 1
	current_player = Player.HERO
	battle_over = false
	set_up_ui()


func _on_move_button_pressed(move_id: int) -> void:
	if battle_over or current_player != Player.HERO:
		return
	handle_hero_move(RunState.moves[move_id])
		
		
func handle_hero_move(move: Move) -> void:
	resolve_move(hero, monster, move)
	if not battle_over: 
		request_monster_move()
		refresh_ui()
		
		
func handle_monster_move(move: Move) -> void:
	resolve_move(monster, hero, move)
	turn += 1
	if not battle_over: refresh_ui()
	
	
func request_monster_move() -> void:
	move_label.text = MONSTER_THINKING_STR
	
	var move = await APIClient.get_monster_move(monster.str_id, monster.hp, monster.max_hp, hero.hp, hero.max_hp, turn)
	if move == null:
		current_player = Player.HERO
		refresh_ui()
		return
	
	handle_monster_move(move)
	
	
func resolve_move(caster: Fighter, target: Fighter, move: Move):
	print("\n--- Turn %d: %s uses %s ---" % [turn, Player.keys()[current_player], move.name])
	
	match move.effect:
		Move.EFFECT.DAMAGE:
			if move.type == Move.TYPE.MAGIC:
				target.take_magic_damage(move.base_value + caster.magic)
			else:
				target.take_damage(move.base_value + caster.attack)
		Move.EFFECT.HEAL:
			caster.heal(move)
	
	current_player = (current_player+1)%2 as Player
	
	if target.is_dead():
		end_battle()
	
func end_battle() -> void:
	battle_over = true
	refresh_ui()
	move_label.text = END_STR[(current_player+1)%2]
	if current_player == Player.MONSTER and RunState.current_encounter_index == RunState.max_encounter_index:
		RunState.max_encounter_index += 1


func set_up_ui() -> void:
	$StatsContainer/HeroUI.bind(hero)
	$StatsContainer/MonsterUI.bind(monster)
	
	back_button.visible = false
	
	for i in range(hero.move_ids.size()):
		var move_id = hero.move_ids[i]
		move_buttons[i].text = RunState.moves[move_id].name
		move_buttons[i].pressed.connect(_on_move_button_pressed.bind(move_id))
		move_buttons[i].tooltip_text = RunState.moves[move_id].description
		
	refresh_ui()


func refresh_ui() -> void:
	if battle_over:
		back_button.visible = true
		move_buttons_container.visible = false
		return
	
	move_label.text = MOVE_STR[current_player]
	move_buttons_container.visible = (current_player == Player.HERO)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)
