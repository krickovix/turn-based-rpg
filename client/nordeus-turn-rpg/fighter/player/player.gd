class_name Player
extends Fighter

const HEALTH_GAIN = 10
const ATTACK_GAIN = 3
const DEFENSE_GAIN = 2
const MAGIC_GAIN = 1

var xp: int = 0
var level: int = 1

var equipped_move_ids: Array[int] = []


func gain_xp(amount: int) -> int:
	xp += amount
	var levels_gained := 0
	while xp >= level_threshold():
		levels_gained += 1
		level_up()
	return levels_gained
		
func level_up():
	level += 1
	max_hp += HEALTH_GAIN
	attack += ATTACK_GAIN
	defense += DEFENSE_GAIN
	magic += MAGIC_GAIN

func level_threshold() -> int:
	return 100 * 2**(level - 1)
	
func swap_equipped(slot_index: int, new_move_id: int) -> void:
	if slot_index >= equipped_move_ids.size() or slot_index < 0: 
		return
	equipped_move_ids[slot_index] = new_move_id
