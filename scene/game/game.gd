extends Node2D

class_name Game

static var default: Game = null

@onready var camera_2d: Camera2D = $Camera2D
@onready var music_player: AudioStreamPlayer2D = $MusicPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default = self

	print("Hello PlayWithFire")
	Global.reset_data()
	Global.game_start()

	music_player.finished.connect(func() -> void:
		music_player.play()
	)

func _exit_tree() -> void:
	if default == self:
		default = null