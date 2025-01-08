extends CharacterBody2D

# Adjustable variables
@export var gravity: float = 350.0
@export var flap_strength: float = 200.0
@export var jeet_strength: float = 200.0

@onready var sprite: AnimatedSprite2D = $Sprite

var level_lost_scene: PackedScene = load("res://src/scenes/overlaid_menus/level_lost_menu.tscn")
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
		_show_lose_screen()

	position.y += velocity.y * delta
	move_and_slide()

func _show_lose_screen() -> void:
	if level_lost_scene:
		var instance = level_lost_scene.instantiate()
		get_tree().current_scene.add_child(instance)
