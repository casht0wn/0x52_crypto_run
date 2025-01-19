extends CharacterBody2D

# Adjustable variables
@export var gravity: float = 350.0
@export var flap_strength: float = 200.0
@export var jeet_strength: float = 200.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var coins: CPUParticles2D = $Coins
@onready var bills: CPUParticles2D = $Bills

@onready var level: Node2D = get_tree().get_first_node_in_group("Level")

signal died

func _ready() -> void:
	if level:
		connect("died", level.game_over)

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += gravity * delta

	# Check for upward flap input
	if Input.is_action_just_pressed("buy"):
		bills.emitting = true
		coins.emitting = true
		velocity.y = -flap_strength

	# Check for downward flap input
	if Input.is_action_just_pressed("jeet"):
		velocity.y += jeet_strength

	# Make sprite 'bob' when flapping
	if velocity.y > 0:
		sprite.rotation = lerpf(sprite.rotation,deg_to_rad(5.0),0.5)
	else:
		sprite.rotation = lerpf(sprite.rotation,deg_to_rad(-5.0),0.5)

	if position.y > get_viewport_rect().size.y:
		died.emit()

	position.y += velocity.y * delta
	move_and_slide()
