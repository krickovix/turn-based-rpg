class_name FloatingText
extends RichTextLabel

const RISE_DISTANCE := 60.0
const DURATION := 1.2
const FADE_START_RATIO := 0.5  

func show_text(bbcode_str: String, start_pos: Vector2) -> void:
	text = bbcode_str
	global_position = start_pos
	modulate.a = 1.0
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(
		self, "global_position:y",
		start_pos.y - RISE_DISTANCE,
		DURATION
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		self, "modulate:a",
		0.0,
		DURATION * (1.0 - FADE_START_RATIO)
	).set_delay(DURATION * FADE_START_RATIO)
	
	tween.chain().tween_callback(queue_free)
