class_name Global

static var score: int = 0:
    set(value):
        print("Score changed to: ", value)
        if score != value:
            Events.on_score_changed.emit()
        score = value
    get:
        return score

static func reset_data() -> void:
    score = 0

