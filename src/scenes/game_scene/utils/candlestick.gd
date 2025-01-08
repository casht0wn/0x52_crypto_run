extends Node2D

# Adjustable variables
@export var candle_color: Color = Color(1, 1, 1) # Default white
@export var candle_length: float = 50.0          # Candle height
@export var candle_width: float = 20.0           # Candle width
@export var top_wick_length: float = 50.0        # Top wick height
@export var bottom_wick_length: float = 50.0     # Bottom wick height
@export var wick_width: float = 2.0              # Wick width

func _ready():
	update_candle()

func update_candle():
	# Get references to child nodes
	var candle_body = $CandleBody
	var top_wick = $TopWick
	var bottom_wick = $BottomWick

	# Update CandleBody
	candle_body.color = candle_color
	candle_body.size = Vector2(candle_width, candle_length)

	# Update TopWick
	var top_length = top_wick_length * randf()
	top_wick.color = candle_color
	top_wick.size = Vector2(wick_width, top_length)
	top_wick.position = Vector2((candle_width - wick_width) / 2, -top_length) # Position above CandleBody

	# Update BottomWick
	var bottom_length = bottom_wick_length * randf()
	bottom_wick.color = candle_color
	bottom_wick.size = Vector2(wick_width, bottom_length)
	bottom_wick.position = Vector2((candle_width - wick_width) / 2, candle_length) # Position below CandleBody
