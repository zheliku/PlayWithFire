extends Node

var score: int = 0:
    set(value):
        print("Score changed to: ", value)
        if score != value:
            score = value
            Events.on_score_changed.emit()
        if score > best_score:
            best_score = score
    get:
        return score

var best_score: int = 0:
    set(value):
        if best_score < value:
            best_score = value
            Events.on_best_score_changed.emit()
    get:
        return best_score

func _ready() -> void:
    reset_data()
    load_best_score()

    Events.on_best_score_changed.connect(save_best_score)

func reset_data() -> void:
    score = 0

func save_best_score() -> void:
    var file = ConfigFile.new()
    file.set_value("user_data", "best_score", best_score)
    file.save("user://game_data.cfg")

func load_best_score() -> void:
    var file = ConfigFile.new()
    var err = file.load("user://game_data.cfg")
    if err == OK:
        best_score = file.get_value("user_data", "best_score", 0)
    else:
        best_score = 0