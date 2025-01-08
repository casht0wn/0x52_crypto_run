extends Node2D

@export var pipe_scene: PackedScene
@export var pipe_spacing: float = 500.0 # Distance between pipes
@export var base_scroll_speed: float = 250.0 # Base speed of obstacles and candles
@export var height_increase_rate: float = 0.5 # Rate at which the average height increases
@export var gap_size: float = 250.0 # Default gap size between pipes
@export var vertical_scroll_acceleration: float = 0.5 # Acceleration rate for vertical scrolling

@onready var player: CharacterBody2D = get_node("../Pepe") # Update the path to the player node

var elapsed_distance: float = 0.0
var pipes: Array[Node2D] = []
var average_pipe_height: float = 200.0 # Initial average height of pipes
var vertical_scroll_speed: float = 0.0 # Initial vertical scroll speed

func _process(delta: float) -> void:
	# Adjust scroll speed based on player's vertical velocity
	var scroll_speed = base_scroll_speed + player.velocity.y * 0.2

	# Increase vertical scroll speed over time
	vertical_scroll_speed += vertical_scroll_acceleration * delta

	# Move pipes to the left and downward
	for pipe in pipes:
		pipe.position.x -= scroll_speed * delta
		pipe.position.y += vertical_scroll_speed * delta

		# Remove pipes that move off-screen
		if pipe.position.x < -100: # Adjust for off-screen limit
			pipes.erase(pipe)
			pipe.queue_free()

	# Spawn new pipes as needed
	elapsed_distance += scroll_speed * delta
	if elapsed_distance >= pipe_spacing:
		spawn_pipe()
		elapsed_distance = 0.0

	# Gradually increase the average pipe height
	average_pipe_height -= height_increase_rate * delta

func spawn_pipe() -> void:
	# Create a new pipe pair (top and bottom)
	var top_pipe = pipe_scene.instantiate() as Node2D
	var bottom_pipe = pipe_scene.instantiate() as Node2D

	# Calculate the gap position and size
	var gap_position = average_pipe_height + randi_range(-150, 150)
	var gap_variation = randi_range(-20, 200)
	var actual_gap_size = gap_size + gap_variation

	# Set the positions of the top and bottom pipes
	top_pipe.position = Vector2(1280, gap_position - actual_gap_size / 2 - top_pipe.pipe_length)
	bottom_pipe.position = Vector2(1280, gap_position + actual_gap_size / 2)

	# Add the pipes to the scene
	add_child(top_pipe)
	add_child(bottom_pipe)
	pipes.append(top_pipe)
	pipes.append(bottom_pipe)
