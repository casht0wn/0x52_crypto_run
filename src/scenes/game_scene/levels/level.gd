extends Node2D

@onready var score_counter = $CanvasLayer/ScoreCounter

var score: int = 0

func _ready():
	update_score()

func update_score():
	score_counter.display_digits(score)

func _process(delta: float) -> void:
	# Example of updating the score
	score += 1
	update_score()
