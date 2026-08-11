extends Panel

class_name UIGameOver

@onready var current: Label = $Current
@onready var best: Label = $Best
@onready var button: Button = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

	Events.on_score_changed.connect(func() -> void:
		current.text = "Current: %d" % Global.score
	)
	Events.on_best_score_changed.connect(func() -> void:
		best.text = "Best: %d" % Global.best_score
	)

	current.text = "Current: %d" % Global.score
	best.text = "Best: %d" % Global.best_score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()