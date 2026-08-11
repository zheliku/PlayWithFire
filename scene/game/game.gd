extends Node2D

@export var small_fire_scene: PackedScene = preload("res://scene/attack/small_fire/small_fire.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello PlayWithFire")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		var small_fire := small_fire_scene.instantiate() as Node2D
		small_fire.global_position = get_global_mouse_position()
		small_fire.show()
		get_tree().get_root().add_child(small_fire)
