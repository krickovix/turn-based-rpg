extends Node

var hero: Player
var monsters: Array[Fighter] = []
var moves: Array[Move] = []
var run_active: bool = false
var max_encounter_index: int = 0 
var current_encounter_index: int = 0


func start_new_run() -> void:
	max_encounter_index = 0
	current_encounter_index = 0
	run_active = true

func end_run() -> void:
	hero = null
	monsters = []
	moves = []
	run_active = false	
	
func roll_learned_move(monster: Fighter) -> Move:
	var available: Array[int] = []
	for move_id in monster.move_ids:
		if move_id in hero.move_ids:
			continue
		available.append(move_id)
	
	if available.is_empty():
		return null
	
	var chosen_id: int = available.pick_random()
	hero.move_ids.append(chosen_id)
	return get_move_from_id(chosen_id)

func get_move_from_id(id: int) -> Move:
	for move in moves:
		if move.id == id:
			return move
	return null
	
func get_move_from_string(move_string_id: String) -> Move:
	for move in moves:
		if move.string_id == move_string_id:
			return move
	return null
