class_name BattleLog
extends PanelContainer

const MAX_ENTRIES := 30 
const TYPED_TEXT_LABEL = preload("uid://y6hqpvt7liq3")

@onready var entries_container: VBoxContainer = $MarginContainer/ScrollContainer/EntriesContainer
@onready var scroll_container: ScrollContainer = $MarginContainer/ScrollContainer

const HERO_COLOR := Color(0.7, 0.85, 1.0)    
const MONSTER_COLOR := Color(1.0, 0.7, 0.65) 

enum Side { HERO, MONSTER }


func _ready() -> void:
	scroll_container.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER

func add_entry(text: String) -> void:
	var label: TypedTextLabel = TYPED_TEXT_LABEL.instantiate()
	entries_container.add_child(label)
	label.custom_minimum_size = Vector2(250, 20)
	label.type_text(text)
	
	while entries_container.get_child_count() > MAX_ENTRIES:
		entries_container.get_child(0).queue_free()
	
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func clear() -> void:
	for child in entries_container.get_children():
		child.queue_free()
