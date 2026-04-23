extends Area2D

# Initialized states
var is_dragging = false
var viewport_size = null
var taskbar_height = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_size = get_viewport().size
	position = Vector2(viewport_size.x - 350, viewport_size.y - taskbar_height)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Mouse passthrough transparent window logic
	var hitbox_size = %CollisionShape2D.shape.size
	var hitbox_array = [position + Vector2(-hitbox_size.x/2, -hitbox_size.y/2), position + Vector2(hitbox_size.x/2, -hitbox_size.y/2), position + Vector2(-hitbox_size.x/2, hitbox_size.y/2), position + Vector2(hitbox_size.x/2, hitbox_size.y/2)]
	get_window().mouse_passthrough_polygon = hitbox_array

	#Clamping Border logic
	position.x = clamp(position.x,0, viewport_size.x)
	position.y = clamp(position.y,0, viewport_size.y - taskbar_height)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		is_dragging = true
	if event is InputEventMouseButton and not event.is_pressed():
		is_dragging = false	
		position = Vector2(event.position.x, viewport_size.y )
		
	if event is InputEventMouseMotion and is_dragging:
		position = event.position
		
