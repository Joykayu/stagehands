extends Node

@export var music_stream_path := "res://assets/audio/musiques/full_music.mp3"
@export var ambient_stream_path := "res://assets/audio/musiques/bbc_d-i-y--and_07045169.mp3"
@export var bell_stream_path := "res://assets/audio/sound effects/universfield-single-church-bell-2-352062.mp3"

@export var music_volume_normal_db := -24.0
@export var music_volume_puzzle_db := -8.0
@export var ambient_volume_db := -16.0
@export var ambient_muted_db := -60.0
@export var fade_duration := 1.0
@export var bell_volume_db := 6.0

var music_tween : Tween
var ambient_tween : Tween

func _ready():
	%MusicPlayer.stream = load(music_stream_path)
	%MusicPlayer.stream.loop = true
	%MusicPlayer.volume_db = music_volume_normal_db

	%AmbientPlayer.stream = load(ambient_stream_path)
	%AmbientPlayer.stream.loop = true
	%AmbientPlayer.volume_db = ambient_volume_db

	%BellPlayer.stream = load(bell_stream_path)
	%BellPlayer.volume_db = bell_volume_db


func start():
	%MusicPlayer.play()
	%AmbientPlayer.play()


func play_transition_bell():
	%BellPlayer.stop()
	%BellPlayer.play()


func enter_puzzle():
	_fade_music(music_volume_puzzle_db)
	_fade_ambient_out()


func exit_puzzle():
	_fade_music(music_volume_normal_db)
	_fade_ambient_in()


func _fade_music(target_db):
	if music_tween:
		music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(%MusicPlayer, "volume_db", target_db, fade_duration)


func _fade_ambient_out():
	if ambient_tween:
		ambient_tween.kill()
	ambient_tween = create_tween()
	ambient_tween.tween_property(%AmbientPlayer, "volume_db", ambient_muted_db, fade_duration)
	ambient_tween.tween_callback(func(): %AmbientPlayer.stream_paused = true)


func _fade_ambient_in():
	if ambient_tween:
		ambient_tween.kill()
	%AmbientPlayer.stream_paused = false
	ambient_tween = create_tween()
	ambient_tween.tween_property(%AmbientPlayer, "volume_db", ambient_volume_db, fade_duration)
