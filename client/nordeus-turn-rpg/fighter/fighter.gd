class_name Fighter

signal hp_changed(new_hp: int, max_hp: int)
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

var move_ids: Array[int] = []

func is_dead() -> bool:
	return hp <= 0

func take_damage(amount: int) -> void:
	hp += defense - amount
	print("%s takes %d damage: %d / %d" % [name, defense - amount, hp, max_hp])
	
	
func take_magic_damage(amount: int) -> void:
	hp -= amount
	print("%s takes %d magic damage: %d / %d" % [name, amount, hp, max_hp])
	
	
func heal(move: Move) -> void:
	hp += move.base_value + magic
	print("%s heals %d: %d / %d" % [name, move.base_value + magic, hp, max_hp])
