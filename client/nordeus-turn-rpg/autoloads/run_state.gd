extends Node

var hero: Fighter
var monsters: Array[Fighter] = []
var moves: Array[Move] = []
var run_active: bool = false
var level: int = 0
var max_encounter_index: int = 0 
var current_encounter_index: int = 0


func start_new_run() -> void:
	max_encounter_index = 0
	current_encounter_index = 0
	run_active = true
	level = 1


func end_run() -> void:
	hero = null
	monsters = []
	moves = []
	run_active = false
	level = 0
	
	
func get_move_from_string(move_string_id: String) -> Move:
	for move in moves:
		if move.string_id == move_string_id:
			return move
	return null
