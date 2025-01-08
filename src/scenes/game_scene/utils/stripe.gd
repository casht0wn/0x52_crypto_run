extends Node2D

@export var scroll_speed: float = 50.0 # Initial speed of stripe movement
@export var amplitude: float = 1.0 # Initial amplitude of the stripe
@export var line_width: float = 3.0 # Initial width of the stripe

@onready var line: Line2D = $Line

const VU_COUNT = 16.0
const FREQ_MAX = 11050.0

const WIDTH = 1400
const HEIGHT = 250
const HEIGHT_SCALE = 8.0
const MIN_DB = 60
const ANIMATION_SPEED = 0.1

var spectrum
var min_values = []
var max_values = []

func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	min_values.resize(VU_COUNT)
	max_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.fill(0.0)
	update_stripe()

func update_stripe():
	# Update the line points based on the amplitude
	var points = []
	for i in range(0, WIDTH, (WIDTH / VU_COUNT)): # Adjust the range and step based on your needs
		points.append(Vector2(i, amplitude * sin(i * 0.1)))
	line.points = points
	line.width = line_width

func _draw() -> void:
	var points = []
	var min_id = 0
	var max_id = 0
	for i in range(VU_COUNT * 2):
		#Alternate between min and max values to create a zig zag effect
		if i % 2 == 0:
			points.append(Vector2(i * (WIDTH / (VU_COUNT * 2)), -min_values[min_id] * sin(i * 0.1)))
			min_id += 1
		else:
			points.append(Vector2(i * (WIDTH / (VU_COUNT * 2)), -max_values[max_id] * sin(i * 0.1)))
			max_id += 1
	line.points = points
	line.width = line_width

func _process(_delta: float) -> void:
	var data = []
	var prev_hz = 0

	for i in range(1, VU_COUNT + 1):
		var hz = i * FREQ_MAX / VU_COUNT
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length() * amplitude
		var energy = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height = energy * HEIGHT * HEIGHT_SCALE
		data.append(height)
		prev_hz = hz

	for i in range(VU_COUNT):
		if data[i] > max_values[i]:
			max_values[i] = data[i]
		else:
			max_values[i] = lerp(max_values[i], data[i], ANIMATION_SPEED)

		if data[i] <= 0.0:
			min_values[i] = lerp(min_values[i], 0.0, ANIMATION_SPEED)

	# Sound plays back continuously, so the graph needs to be updated every frame.
	queue_redraw()
