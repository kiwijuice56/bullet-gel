# Keep the score on the bottom left updated.
class_name ScoreLabel
extends Label

func _ready() -> void:
	GlobalState.score_updated.connect(_on_score_updated)

func _on_score_updated() -> void:
	text = "score: " + str(GlobalState.score)
