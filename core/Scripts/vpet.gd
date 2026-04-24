extends Area2D

# Initialized states
var is_dragging = false
var viewport_size = null
var taskbar_height = 120
var is_mouse_over = false
var walk_direction = 1

@export var walk_speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport().size
	position = Vector2(viewport_size.x - 350, viewport_size.y - taskbar_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += walk_direction * walk_speed * delta
	#Clamping Border logic
	position.x = clamp(position.x,0, viewport_size.x)
	position.y = clamp(position.y,0, viewport_size.y - taskbar_height)

func _input(event):
	if event is InputEventMouseButton and is_mouse_over and event.is_pressed():
		is_dragging = true
	if event is InputEventMouseButton and is_mouse_over and not event.is_pressed():
		is_dragging = false	
		position = Vector2(event.position.x, viewport_size.y )
		
	if event is InputEventMouseMotion and is_mouse_over and is_dragging:
		position = event.position
		
func _on_mouse_entered():
	is_mouse_over = true
	get_window().mouse_passthrough_polygon = []

func _on_mouse_exited():
	is_mouse_over = false
	var viewport_array = [Vector2(0, 0), Vector2(viewport_size.x, 0), Vector2(viewport_size.x, viewport_size.y), Vector2(0, viewport_size.y)]
	get_window().mouse_passthrough_polygon = viewport_array
