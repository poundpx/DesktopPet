extends Area2D

# Initialized states
var is_dragging = false
var viewport_size = null
var taskbar_height = 120
var is_mouse_over = false
var walk_direction = 1
var isWalking = false

var target_position = Vector2.ZERO
var is_commuting = false
var ui_reference: Node = null # Holds onto the UI so we can talk back to it later
#increase walk speed 
@export var walk_speed = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport().size
	position = Vector2(viewport_size.x - 350, viewport_size.y - taskbar_height)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 1. IDLE WALK: Only run if we are NOT actively commuting
	if not is_dragging and isWalking and not is_commuting:
		position.x += walk_direction * walk_speed * delta
		
	# 2. CLAMPING
	position.x = clamp(position.x, 0, viewport_size.x)
	position.y = clamp(position.y, 0, viewport_size.y - taskbar_height)
	
	# 3. COMMUTE WALK
	if is_commuting:
		position = position.move_toward(target_position, walk_speed * delta)
		
		if target_position.x > position.x:
			walk_direction = 1
		else:
			walk_direction = -1
			
		# Use 5.0 pixels as a safety net so the math doesn't overshoot
		if position.distance_to(target_position) < 5.0:
			position = target_position # Snap exactly to the spot
			is_commuting = false
			walk_direction = 1
			$AnimatedSprite2D.flip_h = false
			if ui_reference:
				ui_reference.begin_actual_countdown()

func _input(event):
	if event is InputEventMouseButton and is_mouse_over and event.button_index==MOUSE_BUTTON_LEFT and event.is_pressed():
		is_dragging = true
		$FSM_Node._pick_pickup()
	if event is InputEventMouseButton and is_mouse_over and event.button_index==MOUSE_BUTTON_LEFT and not event.is_pressed():
		is_dragging = false	
		$FSM_Node._pick_interact()
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

func start_pomo_commute(source_ui: Node):
	# Grab a fresh viewport size just in case the window was resized
	viewport_size = get_viewport().size 
	
	target_position = Vector2(viewport_size.x - 200, viewport_size.y - taskbar_height)
	ui_reference = source_ui
	is_commuting = true
	$FSM_Node._pick_walk()
