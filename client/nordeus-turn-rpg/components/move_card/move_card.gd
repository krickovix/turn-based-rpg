class_name MoveCard extends VBoxContainer

const MOVE_CARD = preload("uid://yuvr8u8fwvs5")
const MOVE_TOOLTIP = preload("uid://b7q3ll3dgldtr")

@onready var name_label: Label = $NameLabel
@onready var icon_container: CenterContainer = $IconContainer
@onready var icon_texture: TextureRect = $IconContainer/IconTexture
@onready var icon_button: Button = $IconContainer/IconButton

var move: Move
static var selected_slot: MoveSlot
static var tooltip: MoveTooltip

func set_move(m: Move) -> void:
	move = m
	name_label.text = move.name
	icon_button.icon = m.icon
	
func set_large() -> void:
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
		return
	
	selected_slot.set_move(move)
	var moveset_manager = get_parent()
	while not moveset_manager is MovesetManager:
		moveset_manager = moveset_manager.get_parent()
	if moveset_manager: moveset_manager.refresh_pool()
	selected_slot = null

func _on_mouse_entered() -> void:
	if tooltip:
		tooltip.queue_free()
		
	tooltip = MOVE_TOOLTIP.instantiate()
	TooltipLayer.add_child(tooltip)
	tooltip.position = get_global_mouse_position() + Vector2(16, 16) 
	tooltip.populate(move)
	tooltip.fade_in()

func _on_mouse_exited() -> void:
	if tooltip and is_instance_valid(tooltip):
		tooltip.fade_out_and_free()
		tooltip = null
