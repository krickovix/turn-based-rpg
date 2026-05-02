class_name MoveCard extends Button

const MOVE_CARD = preload("uid://yuvr8u8fwvs5")

var move: Move
static var selected_slot: MoveSlot

func set_move(m: Move) -> void:
	move = m
	text = move.name
	tooltip_text = move.description

func _on_pressed() -> void:
	if get_parent() is MoveSlot:
		selected_slot = get_parent()
		modulate = Color(0.875, 0.851, 0.4, 1.0)  
		return
	
	if not selected_slot:
		print("You have to select a move slot first")
		return
	
	selected_slot.set_move(move)
	var moveset_manager = get_parent()
	while not moveset_manager is MovesetManager:
		moveset_manager = moveset_manager.get_parent()
	if moveset_manager: moveset_manager.refresh_pool()
	selected_slot = null
