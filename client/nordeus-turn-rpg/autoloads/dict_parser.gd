extends Node

const MOVE_EFFECTS = ["damage", "heal", "buff", "debuff"]
const MOVE_TYPES = ["physical", "magic"]

static func parse_hero(hero_dict: Dictionary) -> Fighter:
	var hero: Fighter = Fighter.new()
	hero.name = hero_dict["name"]
	hero.max_hp = int(hero_dict["base_stats"]["health"])
	hero.hp = hero.max_hp
	hero.attack = hero_dict["base_stats"]["attack"]
	hero.defense = hero_dict["base_stats"]["defense"]
	hero.magic = hero_dict["base_stats"]["magic"]
	hero.move_ids = []
	for move_str in hero_dict["default_moves"]:
		var move = RunState.get_move_from_string(move_str)
		if move: hero.move_ids.append(move.id)
	
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
	
	return monster
	
	
static func parse_move(move_dir: Dictionary) -> Move:
	var move = Move.new()
	move.string_id = move_dir["id"]
	move.name = move_dir["name"]
	move.effect = MOVE_EFFECTS.find(move_dir["effect"]) as Move.EFFECT
	move.type = MOVE_TYPES.find(move_dir["type"]) as Move.TYPE
	move.base_value = move_dir["base_value"]	
	move.description = move_dir["description"]
	return move
	
	
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
		
		
func create_monster_move_params(monster_str_id: String, monster_hp: int, monster_max_hp: int, 
								hero_hp: int, hero_max_hp: int, turn: int) -> Dictionary:
	return {
		"encounter_index": RunState.current_encounter_index,
		"monster_id": monster_str_id,
		"monster_hp": monster_hp,
		"monster_max_hp": monster_max_hp,
		"hero_hp": hero_hp,
		"hero_max_hp": hero_max_hp,
		"turn_number": turn
	}
