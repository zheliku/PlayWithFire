extends Node2D

@export var enemy_scene: PackedScene = preload("res://scene/enemy/enemy.tscn")
@export var generation_interval: float = 1.0

var enemy_gen_positions: Array[Marker2D] = []
var current_seconds: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			enemy_gen_positions.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_seconds += delta
	if current_seconds >= generation_interval:
		current_seconds -= generation_interval
		var enemy := enemy_scene.instantiate() as Enemy
		var marker2D = enemy_gen_positions.pick_random() as Marker2D
		enemy.global_position = marker2D.global_position
		enemy.show()
		Game.default.add_child(enemy)
