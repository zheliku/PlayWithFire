extends CharacterBody2D

class_name Enemy

@export var speed = 100.0
@export var power_up_longer_fire_scene: PackedScene
@export var power_up_big_fire_scene: PackedScene

@onready var die_sfx_player: AudioStreamPlayer2D = $DieSfxPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: Area2D = $HitBox
@onready var shadow: ColorRect = $Sprite2D/Shadow

var died: bool = false

func _physics_process(delta: float) -> void:
	if died:
		return
	
	if Player.default == null:
		return

	var direction_to_player := position.direction_to(Player.default.position)
	velocity = direction_to_player * speed

	move_and_slide()


func _on_hit_box_body_entered(body: Node2D) -> void:
	print("Enemy hit by: ", body.name)
	if body.is_in_group("Player"):
		var player := body as Player
		player.kill(false)

func kill() -> void:
	Global.score += 1
	Game.default.camera_2d.shake(10)

	died = true
	die_sfx_player.play()
	sprite_2d.scale.y = 1

	var material_instance := sprite_2d.material.duplicate() as ShaderMaterial
	sprite_2d.material = material_instance
	create_tween().tween_method(func(v):
		material_instance.set_shader_parameter("dissolve_value", v)
	, 1.0, 0, 0.75)
	create_tween().tween_property(shadow, "modulate", Color(0, 0, 0, 0), 0.75)

	collision_shape_2d.queue_free()
	hit_box.queue_free()

	get_tree().create_timer(0.75).timeout.connect(self.queue_free)

	var random_value = randi() % 100
	if random_value < 10:
		var power_up_longer_fire := power_up_longer_fire_scene.instantiate() as Node2D
		power_up_longer_fire.global_position = global_position
		Game.default.call_deferred("add_child", power_up_longer_fire)
	elif random_value < 80 and not Global.big_fire:
		var power_up_big_fire := power_up_big_fire_scene.instantiate() as Node2D
		power_up_big_fire.global_position = global_position
		Game.default.call_deferred("add_child", power_up_big_fire)
