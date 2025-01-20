extends Node2D

@export var stripe_scene: PackedScene
@export var stripe_spacing: float = 200.0 # Distance between stripes
@export var base_scroll_speed: float = 800.0 # Base speed of stripe movement
@export var amplitude_reduction_rate: float = 0.96 # Rate at which amplitude reduces
@export var speed_reduction_rate: float = 0.985 # Rate at which speed reduces
@export var width_increase_rate: float = 1.01 # Rate at which width increases

@onready var audio_bus_index: int = AudioServer.get_bus_index("Master") # Replace "Master" with the name of your audio bus if different
@onready var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(audio_bus_index, 0) as AudioEffectSpectrumAnalyzerInstance

var elapsed_distance: float = 0.0
var stripes: Array[Node2D] = []

func _ready():
	base_scroll_speed = get_viewport().size.y * speed_reduction_rate

func _process(delta: float) -> void:
	# Move all stripes downward
	for stripe in stripes:
		stripe.position.y += stripe.scroll_speed * delta # Move the stripe down
		stripe.scroll_speed *= speed_reduction_rate		 # Reduce the stripe's speed
		stripe.amplitude *= amplitude_reduction_rate	 # Reduce the stripe's amplitude
		stripe.line_width *= width_increase_rate		 # Increase the stripe's width

		# Remove stripes that move off-screen
		if stripe.position.y > get_viewport().size.y + 100 || stripe.amplitude < 0.00001:
			stripes.erase(stripe)
			stripe.queue_free()

	# Check if we need to spawn a new stripe
	elapsed_distance += base_scroll_speed * delta
	if elapsed_distance >= stripe_spacing:
		spawn_stripe()
		elapsed_distance = 0.0
		
	


func spawn_stripe() -> void:
	# Create a new stripe and position it
	var stripe = stripe_scene.instantiate() as Node2D
	stripe.position = Vector2(0, 0) # Start at the top of the screen
	stripe.scroll_speed = base_scroll_speed
	stripe.amplitude = get_amplitude_from_audio()
	add_child(stripe)
	stripes.append(stripe)

func get_amplitude_from_audio() -> float:
	# Get the amplitude from the audio analyzer
	var spectrum = spectrum_analyzer.get_magnitude_for_frequency_range(20, 20000)
	return spectrum.length()
