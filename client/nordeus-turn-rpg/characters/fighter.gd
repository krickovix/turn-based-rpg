class_name Fighter

var name: String
var hp: int
var max_hp: int
var base_stats: Dictionary  = {}
var effects: Array = []
var moves: Array = []  

func is_dead() -> bool:
	return hp <= 0

func take_damage(amount: int) -> void:
	hp = max(0, hp - amount)

func effective_stat(stat_name: String) -> int:
	var modifier = 0
	for effect in effects:
		if effect["stat"] == stat_name:
			modifier += effect["delta"]
	return max(0, base_stats[stat_name] + modifier)

static func from_hero(hero: Dictionary) -> Fighter:
	var f = Fighter.new()
	f.name = hero["name"]
	f.max_hp = int(hero["base_stats"]["health"])
	f.hp = f.max_hp
	f.base_stats = hero["base_stats"]
	f.moves = hero["default_moves"]
	return f

static func from_monster(encounter: Dictionary) -> Fighter:
	var f = Fighter.new()
	f.name = encounter["name"]
	f.max_hp = int(encounter["stats"]["health"])
	f.hp = f.max_hp
	f.base_stats = encounter["stats"]
	f.moves = encounter["moves"]
	return f
