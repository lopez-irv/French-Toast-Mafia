extends Control

var level_select_music = preload("res://assets/music/level-select-music.wav")

@onready var level_music_player: AudioStreamPlayer2D = $LevelMusicPlayer

func _ready() -> void:
	level_music_player.stream = level_select_music
	level_music_player.play()

func _process(delta: float) -> void:
	pass
