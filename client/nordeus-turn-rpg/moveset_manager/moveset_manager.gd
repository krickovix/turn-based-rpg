class_name MovesetManager
extends Control

const MAP_PATH = "res://map/map.tscn"
const MAP_STR = "Map"
const MAP_TEXTURE = "res://assets/icons/scroll_icon.tres"

const MOVE_CARD = preload("uid://yuvr8u8fwvs5")

const HIGHLIGHT_COLOR = Color(1, 1, 0)

@onready var available_slots_container: GridContainer = $VBoxContainer/AvailableSlotsContainer
@onready var equipped_slots: Array[MoveSlot] = [
	$VBoxContainer/EquippedSlotsContainer/MoveSlot, 
	$VBoxContainer/EquippedSlotsContainer/MoveSlot2, 
	$VBoxContainer/EquippedSlotsContainer/MoveSlot3, 
	$VBoxContainer/EquippedSlotsContainer/MoveSlot4
	]
@onready var icon_button: IconButton = $MarginContainer/IconButton

var selected_equipped_index: int = -1


func _ready() -> void:
	for i in range(equipped_slots.size()):
		equipped_slots[i].slot_index = i
	_populate_equipped_slots()
	refresh_pool()
	icon_button.set_icon(MAP_STR, MAP_TEXTURE)
		
func _populate_equipped_slots():
	var move_ids = RunState.hero.equipped_move_ids
	for i in range(move_ids.size()):
		var move = RunState.get_move_from_id(move_ids[i])
		equipped_slots[i].set_move(move)
	
func refresh_pool():
	for child in available_slots_container.get_children():
		if child is MoveCard:
			child.queue_free()

	for move_id in RunState.hero.move_ids:
		var move = RunState.get_move_from_id(move_id)
		var card = MOVE_CARD.instantiate()
		available_slots_container.add_child(card)
		card.set_move(move)
		card.icon_button.disabled = move_id in RunState.hero.equipped_move_ids

func _on_icon_button_pressed() -> void:
	get_tree().change_scene_to_file(MAP_PATH)
