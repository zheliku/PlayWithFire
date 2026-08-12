extends CharacterBody2D

class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var die_sfx_player: AudioStreamPlayer2D = $DieSfxPlayer
@onready var shadow: Sprite2D = $Sprite2D/Shadow
@onready var message: Label = $Message

static var default: Player = null

@export var speed = 300.0
@export var small_fire_scene: PackedScene = preload("res://scene/attack/small_fire/small_fire.tscn")
@export var big_fire_scene: PackedScene = preload("res://scene/attack/big_fire/big_fire.tscn")

var died: bool = false
var attack_duration: float = 0.2
var current_duration: float = 0.0

func _ready() -> void:
	default = self
	died = false
	message.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Global.running:
		return
	if died:
		return

	current_duration += delta
	if current_duration >= attack_duration and Input.is_action_pressed("fire"):
		current_duration = 0.0
		var fire = big_fire_scene.instantiate() as Node2D if Global.big_fire else small_fire_scene.instantiate() as Node2D

		# var small_fire := small_fire_scene.instantiate() as Node2D
		# small_fire.global_position = get_global_mouse_position()
		# small_fire.show()
		# Game.default.add_child(small_fire)

		fire.global_position = get_global_mouse_position()
		fire.show()
		Game.default.add_child(fire)

func _physics_process(delta: float) -> void:
	if not Global.running:
		return
	if died:
		return

	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()
	_clamp_to_viewport()

func _clamp_to_viewport() -> void:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		return
	var half := get_viewport_rect().size / 2.0 / camera.zoom
	var cam := camera.global_position
	var r := 34.0  # 与 CollisionShape2D 的 radius 保持一致
	position.x = clamp(position.x, cam.x - half.x + r, cam.x + half.x - r)
	position.y = clamp(position.y, cam.y - half.y + r, cam.y + half.y - r)

func _exit_tree() -> void:
	if default == self:
		default = null

func display_message(text: String) -> void:
	var msg = message.duplicate() as Label
	msg.global_position = message.global_position
	msg.text = text
	msg.show()
	msg.modulate = Color.WHITE
	Game.default.add_child(msg)

	var tween := create_tween()
	var to_pos = msg.global_position + Vector2.UP * 32
	tween.tween_property(msg, "global_position", to_pos, 2.0)
	tween.tween_property(msg, "modulate", Color(1, 1, 1, 0), 1.0)
	tween.finished.connect(msg.queue_free)

func kill(by_fire = true) -> void:
	died = true
	sprite_2d.scale.y = 1

	if by_fire:
		var material_instance := sprite_2d.material.duplicate() as ShaderMaterial
		sprite_2d.material = material_instance
		create_tween().tween_method(func(v):
			material_instance.set_shader_parameter("dissolve_value", v)
		, 1.0, 0, 0.75)
		create_tween().tween_property(shadow, "modulate", Color(0, 0, 0, 0), 0.75)

	collision_shape_2d.queue_free()
	die_sfx_player.play()
	Game.default.music_player.stop()

	get_tree().create_timer(0.75).timeout.connect(Global.game_over)
