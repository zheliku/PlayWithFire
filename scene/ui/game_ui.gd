extends CanvasLayer

@onready var score_label: Label = $ScorePanel/ScoreLabel
@onready var best_label: Label = $ScorePanel/BestLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.on_score_changed.connect(update_score)
	Events.on_best_score_changed.connect(update_best_score)

	update_score()
	update_best_score()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score() -> void:
	score_label.text = "Score: %d" % Global.score

func update_best_score() -> void:
	best_label.text = "Best: %d" % Global.best_score
