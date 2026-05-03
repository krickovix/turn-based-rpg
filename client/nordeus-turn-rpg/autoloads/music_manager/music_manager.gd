extends Node

const BATTLE_MUSIC = preload("uid://dlocyq03onium")
const MAP_MUSIC = preload("uid://cg0d5mr1rbbqb")

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var _current_track: AudioStream


func play_track(stream: AudioStream) -> void:
	if _current_track == stream and player.playing:
		return
	
	_current_track = stream
	player.stream = stream
	player.play()

func play_map_music() -> void:
	play_track(MAP_MUSIC)

func play_battle_music() -> void:
	play_track(BATTLE_MUSIC)
