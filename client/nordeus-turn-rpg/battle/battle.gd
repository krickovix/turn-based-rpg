extends Control

signal battle_over(xp_learned: int, levels_gained: int, move_learned: Move)

enum FighterType{HERO, MONSTER}
const MOVE_STR = ["Your move!", "Monster's move!"]
const MONSTER_THINKING_STR = "Monster is thinking..."

@onready var move_label: Label = $MoveUI/MoveLabel
@onready var move_buttons_container: HBoxContainer = $MoveUI/MoveButtons
@onready var move_buttons : Array[Button] = [
	$MoveUI/MoveButtons/Button, 
	$MoveUI/MoveButtons/Button2, 
	$MoveUI/MoveButtons/Button3, 
	$MoveUI/MoveButtons/Button4
]

var turn: int = 0
var current_player: FighterType
var hero: Fighter
var monster: Fighter
var battle_finished: bool

class BattleResult:
	var xp_gained: int = 0
	var levels_gained: int = 0
	var move_learned: Move = null
	
var last_battle_result: BattleResult

func _ready() -> void:
	hero = RunState.hero
	hero.reset_for_battle()
	monster = RunState.monsters[RunState.current_encounter_index]
	monster.reset_for_battle()
	turn = 1
	current_player = FighterType.HERO
	battle_finished = false
	set_up_ui()

func _on_move_button_pressed(move_id: int) -> void:
	if current_player != FighterType.HERO:
		return
	handle_hero_move(RunState.moves[move_id])	
		
func handle_hero_move(move: Move) -> void:
	resolve_move(hero, monster, move)
	request_monster_move()
	refresh_ui()
			
func handle_monster_move(move: Move) -> void:
	resolve_move(monster, hero, move)
	turn += 1
	refresh_ui()
	
func request_monster_move() -> void:
	move_label.text = MONSTER_THINKING_STR
	
	var move = await APIClient.get_monster_move(monster.str_id, monster.hp, monster.max_hp, monster.active_effects,
												hero.hp, hero.max_hp, hero.active_effects, turn)
	if move == null:
		current_player = FighterType.HERO
		refresh_ui()
		return
	
	handle_monster_move(move)
	
func resolve_move(caster: Fighter, enemy: Fighter, move: Move):
	print("\n--- Turn %d: %s uses %s ---" % [turn, FighterType.keys()[current_player], move.name])
	caster.tick_active_effects()
	
	for effect in move.effects:
		var clone := effect.clone()
		clone.caster = caster
		var target := caster if clone.target == Effect.TARGET.SELF else enemy
		target.apply(clone)
		if target.is_dead(): break
	
	current_player = (current_player+1)%2 as FighterType
	
	if enemy.is_dead() or caster.is_dead():
		end_battle()
	
func end_battle() -> void:
	if battle_finished:
		return
	battle_finished = true
	last_battle_result = BattleResult.new()
	if current_player == FighterType.MONSTER:
		hero_progress()
	
	print(hero.move_ids)
	battle_over.emit(last_battle_result.xp_gained, last_battle_result.levels_gained, last_battle_result.move_learned)

func hero_progress():
	if RunState.current_encounter_index == RunState.max_encounter_index:
		RunState.max_encounter_index += 1

	last_battle_result = BattleResult.new()
	last_battle_result.xp_gained = monster.xp_reward
	last_battle_result.levels_gained = hero.gain_xp(monster.xp_reward)
	print("Gained %d XP." % monster.xp_reward)
	
	var learned := RunState.roll_learned_move(monster)
	if learned:
		print("Learned: %s" % learned.name)
		last_battle_result.move_learned = learned
		

func set_up_ui() -> void:
	$StatsContainer/HeroUI.bind(hero)
	$StatsContainer/MonsterUI.bind(monster)
	
	print(hero.equipped_move_ids)
	for i in range(hero.equipped_move_ids.size()):
		var move_id = hero.equipped_move_ids[i]
		move_buttons[i].text = RunState.moves[move_id].name
		move_buttons[i].pressed.connect(_on_move_button_pressed.bind(move_id))
		move_buttons[i].tooltip_text = RunState.moves[move_id].description
		
	refresh_ui()

func refresh_ui() -> void:
	move_label.text = MOVE_STR[current_player]
	move_buttons_container.visible = (current_player == FighterType.HERO)
