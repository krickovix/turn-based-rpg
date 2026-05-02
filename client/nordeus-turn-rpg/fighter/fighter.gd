class_name Fighter
extends RefCounted

signal hp_changed(new_hp: int, max_hp: int)
signal effects_changed
signal died

var index: int = -1
var str_id: String
var name: String

var hp: int:
	set(value):
		var clamped = clamp(value, 0, max_hp)
		if clamped == hp:
			return
		hp = clamped
		hp_changed.emit(hp, max_hp)
		if hp == 0:
			died.emit()

var max_hp: int:
	set(value):
		max_hp = max(1, value)
		hp_changed.emit(hp, max_hp) 

var attack: int
var defense: int
var magic: int
var xp_reward: int = 0

var active_effects: Array[Effect] = []
var move_ids: Array[int] = []

func is_dead() -> bool:
	return hp <= 0
	
func reset_for_battle() -> void:
	hp = max_hp
	active_effects.clear()
	effects_changed.emit()
	
func apply(effect: Effect) -> void:
	effect.applied_on = self
	effect.resolve()
	if effect.turns_remaining > 0:
		active_effects.append(effect)
		effects_changed.emit()
	
func tick_active_effects() -> void:
	var i = active_effects.size()-1
	while i >= 0:
		active_effects[i].tick()
		if active_effects[i].turns_remaining <= 0:
			active_effects.remove_at(i)
		i-=1
	effects_changed.emit()

func effective_attack() -> int:
	return max(0, attack + _stat_modifier(Effect.STAT.ATTACK))

func effective_defense() -> int:
	return max(0, defense + _stat_modifier(Effect.STAT.DEFENSE))

func effective_magic() -> int:
	return max(0, magic + _stat_modifier(Effect.STAT.MAGIC))
	
func _stat_modifier(stat: Effect.STAT) -> int:
	var total := 0
	for effect in active_effects:
		if effect.stat != stat:
			continue
		if effect.type == Effect.TYPE.BUFF:
			total += effect.base_value
		elif effect.type == Effect.TYPE.DEBUFF:
			total -= effect.base_value
	return total
