extends HBoxContainer

var digit_coords = {
	1: Vector2(0, 0),
	2: Vector2(8, 0),
	3: Vector2(16, 0),
	4: Vector2(24, 0),
	5: Vector2(32, 0),
	6: Vector2(0, 8),
	7: Vector2(8, 8),
	8: Vector2(16, 8),
	9: Vector2(24, 8),
	0: Vector2(32, 8)
}

func display_digits(n):
	var s = "%08d" % n
	for i in range(8):
		var digit = int(s[i])
		var texture_rect = get_child(i) as TextureRect
		var atlas_texture = texture_rect.texture as AtlasTexture
		atlas_texture.region = Rect2(digit_coords[digit], Vector2(8, 8))
		texture_rect.texture = atlas_texture
