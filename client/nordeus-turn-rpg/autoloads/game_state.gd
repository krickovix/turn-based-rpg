extends Node

var run_config: Dictionary = {}
var run_active: bool = false
var level: int = 0
var current_encounter: Dictionary = {}


func start_new_run(config: Dictionary) -> void:
	run_config = config
	run_active = true
	level = 1


func end_run() -> void:
	run_config = {}
	run_active = false
	level = 0
