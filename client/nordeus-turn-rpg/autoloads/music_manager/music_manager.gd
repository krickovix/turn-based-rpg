extends Node

const BATTLE_MUSIC = preload("uid://dlocyq03onium")
const MAP_MUSIC = preload("uid://cg0d5mr1rbbqb")

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var _current_track: AudioStream
var _saved_position: float = 0.0
var _saved_track: AudioStream


func play_track(stream: AudioStream) -> void:
	if _current_track == stream and player.playing:
		return
	
	_current_track = stream
	player.stream = stream
	player.play()

func play_map_music() -> void:
	if _saved_track == MAP_MUSIC and _saved_position > 0.0:
		_current_track = MAP_MUSIC
		player.stream = MAP_MUSIC
		player.play(_saved_position)
		_saved_position = 0.0
		_saved_track = null
	else:
		play_track(MAP_MUSIC)

func play_battle_music() -> void:
	if _current_track == MAP_MUSIC and player.playing:
		_saved_track = MAP_MUSIC
		_saved_position = player.get_playback_position()
	
	play_track(BATTLE_MUSIC)
