extends Control

var main_menu_music = preload("res://assets/music/main-menu-music.wav")

@onready var menu_music_player: AudioStreamPlayer2D = $MenuMusicPlayer

func _ready() -> void:
	menu_music_player.stream = main_menu_music
	menu_music_player.play()

func _process(delta: float) -> void:
	pass

func _on_levels_button_pressed() -> void:
	# Change scene when the levels button is pressed.
	get_tree().change_scene_to_file("res://scenes/levelSelection.tscn")
