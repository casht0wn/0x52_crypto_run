extends CharacterBody2D

# Adjustable variables
@export var gravity: float = 350.0
@export var flap_strength: float = 200.0
@export var jeet_strength: float = 200.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Apply gravity
	velocity.y += gravity * delta

	# Check for upward flap input
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -flap_strength

	# Check for downward flap input
	if Input.is_action_just_pressed("ui_down"):
		velocity.y += jeet_strength

	# Make sprite 'bob' when flapping
	if velocity.y > 0:
		sprite.rotation = deg_to_rad(5.0)
	else:
		sprite.rotation = deg_to_rad(-5.0)

	if position.y > get_viewport_rect().size.y:
		die()

	position.y += velocity.y * delta
	move_and_slide()

func die() -> void:
	pass
