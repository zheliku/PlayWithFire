extends CharacterBody2D

class_name Player

static var default: Player = null

@export var speed = 300.0

func _init() -> void:
	default = self

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	print(direction)
	velocity = direction * speed

	move_and_slide()

func _exit_tree() -> void:
	if default == self:
		default = null