class_name MoveCard extends VBoxContainer

const MOVE_CARD = preload("uid://yuvr8u8fwvs5")

@onready var name_label: Label = $NameLabel
@onready var icon_container: CenterContainer = $IconContainer
@onready var icon_button: Button = $IconContainer/IconButton
@onready var icon_texture: TextureRect = $IconContainer/IconTexture

var move: Move
static var selected_slot: MoveSlot

func set_move(m: Move) -> void:
	move = m
	name_label.text = move.name
	icon_button.icon = m.icon
	
func set_big() -> void:
	icon_button.icon = move.icon_big
	icon_texture.custom_minimum_size *= 2

func _on_icon_button_pressed() -> void:
	if get_parent() is MoveSlot:
		if selected_slot and selected_slot != get_parent():
			selected_slot.remove_modulate()
		
		selected_slot = get_parent()
		icon_container.modulate = Color(0.471, 0.64, 1.0, 1.0) 
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
	
func _make_custom_tooltip(_for_text: String) -> Object:
	var label := Label.new()
	label.text = move.description
	label.add_theme_font_size_override("font_size", 24)
	label.custom_minimum_size = Vector2(280, 0)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label
