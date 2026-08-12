extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shadow: ColorRect = $Shadow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(self._on_body_entered)

	get_tree().create_timer(5).timeout.connect(self.queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.fire_burn_seconds += 1.0

		sfx_player.play()

		sprite_2d.queue_free()
		collision_shape_2d.queue_free()
		shadow.queue_free()

		Player.default.display_message("燃烧时长+1s")

		get_tree().create_timer(0.88).timeout.connect(self.queue_free)