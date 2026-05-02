class_name MoveSlot
extends CenterContainer

const MOVE_CARD = preload("uid://yuvr8u8fwvs5")

var slot_index: int = -1


func set_move(move: Move) -> void:
	if move == null: return
	
	_remove_card()
	
	var card: MoveCard = MOVE_CARD.instantiate()
	card.set_move(move)
	add_child(card)
	
	RunState.hero.swap_equipped(slot_index, move.id)

func _remove_card():
	for child in get_children():
		if child is MoveCard:
			child.queue_free()
