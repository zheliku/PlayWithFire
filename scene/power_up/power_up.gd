extends Area2D

class_name PowerUp

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sfx_player: AudioStreamPlayer2D = $SfxPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shadow: ColorRect = $Shadow

var process_area: bool = false
var fly_to_player: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(self._on_body_entered)
	play_appear_animation()
	get_tree().create_timer(5).timeout.connect(self.queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fly_to_player and process_area:
		var player_pos = Player.default.global_position
		var sprite_pos = sprite_2d.global_position
		var distance_to_player = player_pos.distance_to(sprite_pos)
		if distance_to_player < 8:
			execute()
			sfx_player.play()
			sprite_2d.hide()
			collision_shape_2d.disabled = true
			shadow.hide()
			process_area = false

			get_tree().create_timer(0.88).timeout.connect(self.queue_free)
		else:
			sprite_2d.global_position = lerp(sprite_pos, player_pos, 0.1)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		fly_to_player = true
		

func play_appear_animation():
	var up_pos = sprite_2d.position + Vector2.UP * 16 * 5
	var origin_pos = sprite_2d.position
	var tween_up_down = create_tween()
	tween_up_down.tween_property(sprite_2d, "position", up_pos, 0.4).set_ease(Tween.EASE_OUT)
	tween_up_down.tween_interval(0.1)
	tween_up_down.tween_property(sprite_2d, "position", origin_pos, 0.3).set_ease(Tween.EASE_IN)

	var op: int = randi_range(1, 2) == 1 and 1 or -1
	var to_angle = 360 * 5 * op
	var tween_rotate = create_tween()
	tween_rotate.tween_property(sprite_2d, "rotation_degrees", to_angle, 0.8)
	tween_rotate.finished.connect(func():
		process_area = true
	)

func execute():
	pass
