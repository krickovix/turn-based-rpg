class_name TypedTextLabel
extends RichTextLabel

@export var characters_per_second: float = 30.0

func type_text(new_text: String) -> void:
	scroll_active = false 
	fit_content = true 
	bbcode_enabled = true
	text = new_text
	visible_ratio = 0.0
	
	var duration := float(get_total_character_count()) / characters_per_second
	var tween := create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, duration)
