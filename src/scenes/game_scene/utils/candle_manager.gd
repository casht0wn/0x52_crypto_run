extends Node2D

@export var candlestick_scene: PackedScene
@export var trail_spacing: float = 50.0 # Distance between candlesticks
@export var base_scroll_speed: float = 250.0 # Base speed of candlestick movement
@export var vertical_scroll_acceleration: float = 0.5 # Acceleration rate for vertical scrolling

@onready var player: CharacterBody2D = get_node("../Pepe") # Update the path to the player node

var elapsed_distance: float = 0.0
var last_height: float = 0.0
var candlesticks: Array[Node2D] = []
var vertical_scroll_speed: float = 0.0 # Initial vertical scroll speed

func _ready() -> void:
	last_height = player.global_position.y

func _process(delta: float) -> void:
	# Adjust scroll speed based on player's vertical velocity
	var scroll_speed = base_scroll_speed + player.velocity.y * 0.2

	# Increase vertical scroll speed over time
	vertical_scroll_speed += vertical_scroll_acceleration * delta

	# Move all candlesticks to the left
	for candlestick in candlesticks:
		candlestick.position.x -= scroll_speed * delta
		candlestick.position.y += vertical_scroll_speed * delta

		# Remove candlesticks that move off-screen
		if candlestick.position.x < -800: # Adjust based on off-screen limit
			candlesticks.erase(candlestick)
			candlestick.queue_free()

	# Check if we need to spawn a new candlestick
	elapsed_distance += scroll_speed * delta
	if elapsed_distance >= trail_spacing:
		spawn_candlestick()
		elapsed_distance = 0.0

func spawn_candlestick() -> void:
	# Create a new candlestick and position it
	var candlestick = candlestick_scene.instantiate() as Node2D
	candlestick.position = Vector2(player.global_position.x, last_height) # Start at the player's current position
	var candle_length = abs(last_height - player.global_position.y)
	candlestick.candle_length = candle_length
	if player.velocity.y > 0:
		candlestick.candle_color = "#ff3864"
	else:
		candlestick.candle_color = "#2de2e6"
	candlestick.top_wick_length = randi_range(5,15)
	candlestick.bottom_wick_length = randi_range(5,15)
	add_child(candlestick)
	candlesticks.append(candlestick)
	last_height = player.global_position.y
