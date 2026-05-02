extends Node

const STAT_STRINGS = ["health", "attack", "defense", "magic", "none"]
const TYPE_STRINGS = ["damage", "heal", "buff", "debuff"]
const TARGET_STRINGS = ["self", "enemy"]

static func parse_hero(hero_dict: Dictionary) -> Player:
	var hero := Player.new()
	hero.name = hero_dict["name"]
	hero.max_hp = int(hero_dict["base_stats"]["health"])
	hero.hp = hero.max_hp
	hero.attack = hero_dict["base_stats"]["attack"]
	hero.defense = hero_dict["base_stats"]["defense"]
	hero.magic = hero_dict["base_stats"]["magic"]
	hero.move_ids = []
	for move_str in hero_dict["default_moves"]:
		var move := RunState.get_move_from_string(move_str)
		if move: hero.move_ids.append(move.id)
	hero.equipped_move_ids = hero.move_ids.duplicate()
	return hero
	
static func parse_monster(monster_dict: Dictionary) -> Fighter:
	var monster: Fighter = Fighter.new()
	monster.index = monster_dict["index"]
	monster.str_id = monster_dict["monster_id"]
	monster.name = monster_dict["name"]
	monster.max_hp = int(monster_dict["stats"]["health"])
	monster.hp = monster.max_hp
	monster.attack = monster_dict["stats"]["attack"]
	monster.defense = monster_dict["stats"]["defense"]
	monster.magic = monster_dict["stats"]["magic"]
	monster.move_ids = []
	for move_str in monster_dict["moves"]:
		var move = RunState.get_move_from_string(move_str)
		if move: monster.move_ids.append(move.id)
	monster.xp_reward = int(monster_dict.get("xp_reward", 0))
	
	return monster
	
	
static func parse_move(move_dir: Dictionary) -> Move:
	var move := Move.new(move_dir["id"], move_dir["name"], move_dir["description"])
	move.effects = []
	for effect_dir in move_dir["effects"]:
		move.effects.append(parse_effect(effect_dir))
	return move


static func parse_effect(effect_dir: Dictionary) -> Effect:
	var effect := Effect.new()
	effect.stat = STAT_STRINGS.find(effect_dir["stat"]) as Effect.STAT
	effect.type = TYPE_STRINGS.find(effect_dir["type"]) as Effect.TYPE
	effect.target = TARGET_STRINGS.find(effect_dir["target"]) as Effect.TARGET
	effect.base_value = int(effect_dir["base_value"])
	effect.turns_remaining = int(effect_dir["turns_remaining"])
	return effect
	
	
static func parse_next_monster_move(move_dir: Dictionary) -> Move:
	print("REASONING: ", move_dir["reasoning"])
	return RunState.get_move_from_string(move_dir["move_id"])
	
	
static func parse_run_config(config: Dictionary) -> void:
	RunState.moves = []
	for move in config["moves"]:
		RunState.moves.append(parse_move(config["moves"][move]))
		
	RunState.hero = parse_hero(config["hero"])
	
	RunState.monsters = []
	for monster in config["encounters"]:
		RunState.monsters.append(parse_monster(monster))
		
		
static func create_monster_move_params(monster_str_id: String, monster_hp: int, monster_max_hp: int, monster_effects: Array, 
								hero_hp: int, hero_max_hp: int, hero_effects: Array, turn: int) -> Dictionary:
	
	var monster_effects_strings: Array[String] = []
	for e in monster_effects:
		monster_effects_strings.append(_effect_to_string(e))
	var hero_effects_strings: Array[String] = []
	for e in hero_effects:
		hero_effects_strings.append(_effect_to_string(e))
	
	return {
		"encounter_index": RunState.current_encounter_index,
		"monster_id": monster_str_id,
		"monster_hp": monster_hp,
		"monster_max_hp": monster_max_hp,
		"monster_effects": monster_effects_strings,
		"hero_hp": hero_hp,
		"hero_max_hp": hero_max_hp,
		"hero_effects": hero_effects_strings,
		"turn_number": turn
	}
	
static func _effect_to_string(effect: Effect) -> String:
	var stat_str = STAT_STRINGS[effect.stat]
	return "%s:%d:%d" % [stat_str, effect.base_value, effect.turns_remaining]
