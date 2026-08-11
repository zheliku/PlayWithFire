extends CharacterBody2D

class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var die_sfx_player: AudioStreamPlayer2D = $DieSfxPlayer

static var default: Player = null

@export var speed = 300.0

var died: bool = false
var attack_duration: float = 0.2
var current_duration: float = 0.0

func _ready() -> void:
	default = self
	died = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Global.running:
		return
	if died:
		return

	current_duration += delta
	if current_duration >= attack_duration and Input.is_action_pressed("fire"):
		current_duration = 0.0
		var small_fire := Game.default.small_fire_scene.instantiate() as Node2D
		small_fire.global_position = get_global_mouse_position()
		small_fire.show()
		get_tree().get_root().add_child(small_fire)

func _physics_process(delta: float) -> void:
	if not Global.running:
		return
	if died:
		return

	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()

func _exit_tree() -> void:
	if default == self:
		default = null

func kill() -> void:
	died = true
	sprite_2d.scale.y = 1
	collision_shape_2d.queue_free()
	die_sfx_player.play()

	get_tree().create_timer(0.75).timeout.connect(Global.game_over)
