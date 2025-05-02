extends Control

var level_select_music = preload("res://assets/music/level-select-music.wav")

@onready var level_music_player: AudioStreamPlayer2D = $LevelMusicPlayer

func _ready() -> void:
	$MarginContainer/CenterContainer/VBoxContainer/row1/level0.grab_focus()
	player_level_global.health = player_level_global.healthCap
	level_music_player.stream = level_select_music
	level_music_player.play()
	LevelCompletionStatus.keyFlag = false
	print("keyFlag reset")

func _process(delta: float) -> void:
	pass
