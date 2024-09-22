extends Polygon2D

var aabb : Rect2
var coverage : float = 0.0
var last_coverage : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	aabb = Global.get_AABB(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var image = get_viewport().get_texture().get_image()
	var affected_pixels = 0
	var total_pixels = 0
	var red = 0
	var green = 0
	var blue = 0
		
	for x in range(aabb.position.x, aabb.position.x + aabb.size.x):
		for y in range(aabb.position.y, aabb.position.y + aabb.size.y):
			var point = Vector2(x, y)-self.position
			if Geometry2D.is_point_in_polygon(point, self.polygon):
				total_pixels += 1
				var pixel_color : Color = image.get_pixel(x, y)
				if pixel_color.r != pixel_color.g or pixel_color.g != pixel_color.b:  # Check if light has altered the pixel
					affected_pixels += 1
					if pixel_color.r == 1:
						red += 1
					if pixel_color.g == 1:
						green += 1
					if pixel_color.b == 1:
						blue += 1

	coverage = (float(affected_pixels) / total_pixels) * 100.0
	if coverage != last_coverage:
		last_coverage = coverage
		print("Coverage: %5.2f%%   Red:%5.2f  Green:%5.2f   Blue:%5.2f" % [coverage,(float(red)/total_pixels)*100.0,(float(green)/total_pixels)*100.0,(float(blue)/total_pixels)*100.0])
