@tool
extends Area2D

var dragging = false
var rotating = false
var drag_threshold = 0.5  # Inner 50% for dragging

# Store the initial positions and angles when the mouse is pressed
var initial_mouse_pos: Vector2
var initial_object_pos: Vector2
var initial_rotation: float

@export var light_color : Color = Color(1,0,0,1) : set = set_color

var me_selected: bool = false
var curve_pos : float = 0.0
var bounds : Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_color(light_color)
	if Engine.is_editor_hint():
		return
	bounds = Global.get_AABB($CollisionPolygon2D/Polygon2D)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if me_selected:
		curve_pos += delta*7
		if curve_pos > 2*PI:
			curve_pos -= 2*PI
		var strength = 0.9 + 0.1 * cos(curve_pos)
		modulate = Color(strength,strength,strength)
		#print("%5.2f , %5.2f" % [rad_to_deg(curve_pos), strength])


	if dragging:
		# Calculate offset based on initial click position for smooth dragging
		var current_mouse_pos = get_global_mouse_position()
		var offset = current_mouse_pos - initial_mouse_pos
		position = initial_object_pos + offset
	
	if rotating:
		# Calculate the angle difference based on the initial mouse position for smooth rotation
		var current_mouse_pos = get_global_mouse_position()
		var initial_direction = (initial_mouse_pos - position).normalized()
		var current_direction = (current_mouse_pos - position).normalized()
		var angle_difference = current_direction.angle_to(initial_direction)
		rotation = initial_rotation - angle_difference
	
	# Detect mouse release globally
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		rotating = false


func set_color(new_color):
	light_color = new_color
	$CollisionPolygon2D/Polygon2D.color = light_color
	$PointLight2D.color = light_color
	
func deselect():
	me_selected = false
	modulate = Color(1,1,1)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Engine.is_editor_hint():
		return
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			initial_mouse_pos = get_global_mouse_position()
			initial_object_pos = self.position
			initial_rotation = self.rotation
			
			var center = self.position
			var distance_from_center = initial_mouse_pos.distance_to(center)
			var min_dimension = min(bounds.size.x, bounds.size.y)
			var threshold_radius = min_dimension * drag_threshold
			
			if distance_from_center <= threshold_radius:
				# Click is within the inner 50%, start dragging
				dragging = true
				rotating = false
			else:
				# Click is in the outer 50%, start rotating
				rotating = true
				dragging = false
		else:
			# Mouse button released, stop both dragging and rotating
			dragging = false
			rotating = false
