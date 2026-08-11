extends CharacterBody2D

class_name Enemy

@export var speed = 100.0

func _physics_process(delta: float) -> void:
	var direction_to_player := position.direction_to(Player.default.position)
	velocity = direction_to_player * speed

	move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	print("Enemy hit by: ", body.name)
	if body.is_in_group("Player"):
		var player := body as Player
		player.kill()

func kill() -> void:
	Global.score += 1
	self.queue_free()
