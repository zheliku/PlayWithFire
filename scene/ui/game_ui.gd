extends CanvasLayer

@onready var score_label: Label = $ScorePanel/ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_score_changed.connect(update_score)

	update_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score() -> void:
	score_label.text = "Score: %d" % Global.score
