extends Node2D

# Adjustable variables
@export var pipe_length: float = 1000.0        # Pipe length

@onready var pipe_sprite: Sprite2D = get_node("Sprite2D")
@onready var collision: CollisionShape2D = get_node("Area2D/CollisionShape2D")

@onready var level: Node2D = get_tree().get_first_node_in_group("Level")

signal crashed

func _ready() -> void:
	connect("crashed", level.game_over)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		crashed.emit()
