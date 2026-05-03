class_name IconButton
extends Button

@onready var moveset_manager_icon: TextureRect = $MovesetManagerIcon
@onready var moveset_manager_shadow: TextureRect = $MovesetManagerShadow
@onready var label: Label = $Label


func set_icon(t: String, texture_path: String) -> void:
	moveset_manager_icon.texture = load(texture_path)
	moveset_manager_shadow.texture = load(texture_path)
	label.text = t
	
func set_shadow():
	moveset_manager_icon.position += Vector2(-10, -5)

func _on_mouse_entered() -> void:
	if not disabled:
		moveset_manager_icon.position += Vector2(-10, -5)

func _on_mouse_exited() -> void:
	if not disabled:
		moveset_manager_icon.position -= Vector2(-10, -5)
