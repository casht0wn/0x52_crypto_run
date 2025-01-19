extends Node2D

@onready var score_counter = $CanvasLayer/ScoreCounter
@onready var obstacle_manager = $Obstacles
@onready var candle_manager = $Candles

signal level_won
signal level_lost

var level_state : LevelState
var score: int = 0
var win_score: int = 0

func _ready():
	level_state = GameState.get_level_state(scene_file_path)
	win_score = (GameState.get_current_level() + 1) * 10000
	update_score()

func _process(_delta: float) -> void:
	score += 1
	update_score()
	if score >= win_score:
		winner()

func update_score():
	score_counter.display_digits(score)

func game_over():
	level_lost.emit()
	level_state.score = 0

func winner():
	level_won.emit()
	level_state.score = score
