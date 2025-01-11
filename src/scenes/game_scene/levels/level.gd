extends Node2D

@onready var score_counter = $CanvasLayer/ScoreCounter

signal level_won
signal level_lost

var level_state : LevelState
var score: int = 0

func _ready():
	level_state = GameState.get_level_state(scene_file_path)
	update_score()

func _process(_delta: float) -> void:
	# Example of updating the score
	score += 1
	update_score()
	if score >= 1000000:
		winner()

func update_score():
	score_counter.display_digits(score)

func game_over():
	level_lost.emit()

func winner():
	level_won.emit()
