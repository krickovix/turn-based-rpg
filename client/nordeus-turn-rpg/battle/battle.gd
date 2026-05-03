extends Control

signal battle_over(xp_learned: int, levels_gained: int, move_learned: Move)

const TURN_DELAY = 0.8
const ACTION_DELAY = 0.4

enum FighterType{HERO, MONSTER}

@onready var move_cards : Array[MoveCard] = [
	$MarginContainer/MoveCardContainer/MoveCard, 
	$MarginContainer/MoveCardContainer/MoveCard2, 
	$MarginContainer/MoveCardContainer/MoveCard3, 
	$MarginContainer/MoveCardContainer/MoveCard4
]
@onready var battle_log: BattleLog = $MarginContainer/BattleLog

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
	MusicManager.play_battle_music()
	hero = RunState.hero
	hero.reset_for_battle()
	monster = RunState.monsters[RunState.current_encounter_index]
	monster.reset_for_battle()
	turn = 1
	current_player = FighterType.HERO
	battle_finished = false
	set_up_ui()

func _on_move_button_pressed(move: Move) -> void:
	if current_player != FighterType.HERO:
		return
	handle_hero_move(move)	
		
func handle_hero_move(move: Move) -> void:
	resolve_move(hero, monster, move)
	disable_moves()
	await get_tree().create_timer(TURN_DELAY).timeout	
	request_monster_move()
	
func handle_monster_move(move: Move) -> void:
	resolve_move(monster, hero, move)
	enable_moves()
	turn += 1
	
func request_monster_move() -> void:
	var move = await APIClient.get_monster_move(monster.str_id, monster.hp, monster.max_hp, monster.active_effects,
												hero.hp, hero.max_hp, hero.active_effects, turn)
	if move == null:
		current_player = FighterType.HERO
		return
	
	handle_monster_move(move)
	
func resolve_move(caster: Fighter, enemy: Fighter, move: Move):
	caster.tick_active_effects()
	
	var text = "%s used %s" % [caster.name, move.name]
	if move.icon:
		text += "[img=24]%s[/img] " % [move.icon.resource_path]
	battle_log.add_entry(text)
	
	for effect in move.effects:
		var clone := effect.clone()
		clone.caster = caster
		var target := caster if clone.target == Effect.TARGET.SELF else enemy
		target.apply(clone)
		await get_tree().create_timer(ACTION_DELAY).timeout
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
		last_battle_result.move_learned = learned
		

func set_up_ui() -> void:
	$MarginContainer/StatsContainer/HeroUI.bind(hero)
	$MarginContainer/StatsContainer/MonsterUI.bind(monster)
	
	for i in range(hero.equipped_move_ids.size()):
		var move = RunState.get_move_from_id(hero.equipped_move_ids[i])
		move_cards[i].set_move(move)
		move_cards[i].icon_button.pressed.connect(_on_move_button_pressed.bind(move_cards[i].move))
		
func disable_moves() -> void:
	for move_card in move_cards:
		move_card.icon_button.disabled = true
		
func enable_moves() -> void:
	for move_card in move_cards:
		move_card.icon_button.disabled = false
