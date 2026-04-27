class_name Combat

static func compute_damage(move: Dictionary, attacker: Fighter, target: Fighter) -> int:
	if move["effect"] != "damage": return 0
	
	var base_value = int(move["base_value"])
	if move["type"] == "physical":
		return max(1, base_value + attacker.effective_stat("attack") - target.effective_stat("defense"))
	elif move["type"] == "magic":
		return base_value + attacker.effective_stat("magic")
	return 0
