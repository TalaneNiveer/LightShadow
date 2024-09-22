extends Node

var selected : Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected = null


func get_AABB(polygon2d: Polygon2D):
	var global_position = polygon2d.global_position  # Get the global position of the Polygon2D
	var polygon_points = polygon2d.polygon  # Get the local vertices
	
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	# Translate each point by the global position
	for point in polygon_points:
		var global_point = global_position + point  # Transform local point to world space
		min_x = min(min_x, global_point.x)
		max_x = max(max_x, global_point.x)
		min_y = min(min_y, global_point.y)
		max_y = max(max_y, global_point.y)

	var aabb = Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))
	return aabb
