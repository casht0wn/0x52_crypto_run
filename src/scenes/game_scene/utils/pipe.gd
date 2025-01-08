extends Node2D

# Adjustable variables
@export var pipe_color: Color = Color(1, 1, 1) # Default white
@export var pipe_length: float = 800.0         # Pipe length
@export var pipe_width: float = 80.0           # Pipe width
@export var end_length: float = 30.0           # Pipe end length
@export var end_width: float = 90.0            # Pipe end width

@onready var collision: CollisionShape2D = get_node("Area2D/CollisionShape2D")

func _ready():
	update_pipe()
	
func update_pipe():
	# Get references to child nodes
	var pipe_body = $PipeBody
	var pipe_top = $PipeTop
	var pipe_bottom = $PipeBottom

	# Update PipeBody
	pipe_body.color = pipe_color
	pipe_body.size = Vector2(pipe_width, pipe_length)
	collision.shape.size = Vector2(pipe_width, pipe_length)

	var pipe_body_center = pipe_body.position.x + (pipe_width / 2)

	# Update PipeEnd (top)
	pipe_top.color = pipe_color
	pipe_top.size = Vector2(end_width, end_length)
	pipe_top.position = Vector2(pipe_body_center - (end_width / 2), pipe_body.position.y - end_length) # Position above PipeBody

	# Update PipeEnd (bottom)
	pipe_bottom.color = pipe_color
	pipe_bottom.size = Vector2(end_width, end_length)
	pipe_bottom.position = Vector2(pipe_body_center - (end_width / 2), pipe_body.position.y + pipe_length) # Position below PipeBody
