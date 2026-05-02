class_name Effect
extends RefCounted

enum STAT {HEALTH, ATTACK, DEFENSE, MAGIC, NONE}
enum TYPE {DAMAGE, HEAL, BUFF, DEBUFF}
enum TARGET {SELF, ENEMY}

var stat: STAT
var type: TYPE
var target: TARGET
var applied_on: Fighter
var caster: Fighter          
var base_value: int
var turns_remaining: int 

	
func resolve() -> void:
	var modifier := 0
	match stat:
		STAT.ATTACK:
			modifier = caster.effective_attack()
		STAT.MAGIC:
			modifier = caster.effective_magic()
	
	match type:
		TYPE.DAMAGE:
			resolve_damage(modifier)
		TYPE.HEAL:
			resolve_heal(modifier)
	
func tick() -> void:
	turns_remaining -= 1
	
func resolve_damage(modifier: int) -> void:
	var damage = base_value + modifier
	damage -= applied_on.effective_defense() if stat == STAT.ATTACK else 0
	applied_on.hp -=  max(0, damage)	
	print("%s takes %d damage: %d / %d" % [
		applied_on.name, damage,
		applied_on.hp, applied_on.max_hp
	])
		
func resolve_heal(modifier: int) -> void:
	var amount := base_value + modifier
	applied_on.hp += amount
	print("%s heals %d: %d / %d" % [
		applied_on.name, amount, applied_on.hp, applied_on.max_hp
	])
		
func clone() -> Effect:
	var effect := Effect.new()
	effect.stat = stat
	effect.type = type
	effect.target = target
	effect.base_value = base_value
	effect.turns_remaining = turns_remaining
	return effect
