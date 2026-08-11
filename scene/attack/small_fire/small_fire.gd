extends Area2D

@onready var remain_seconds: Label = $RemainSeconds

var current_seconds: float = 0.0
var burn_seconds: float = 1.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_seconds >= burn_seconds:
		current_seconds = burn_seconds
		self.queue_free()
		return
	else:
		current_seconds += delta
		remain_seconds.text = "%0.1f" % (burn_seconds - current_seconds)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		print("Small fire hit enemy: ", body.name)
		var enemy := body as Enemy
		enemy.kill()
		self.queue_free()
	elif body.is_in_group("Player"):
		print("Small fire hit player: ", body.name)
		var player := body as Player
		player.kill()
		self.queue_free()
