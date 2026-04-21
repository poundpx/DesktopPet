extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_viewport().get_visible_rect().size / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var hitbox_size = %CollisionShape2D.shape.size
	var hitbox_array = [position + Vector2(-hitbox_size.x/2, -hitbox_size.y/2), position + Vector2(hitbox_size.x/2, -hitbox_size.y/2), position + Vector2(-hitbox_size.x/2, hitbox_size.y/2), position + Vector2(hitbox_size.x/2, hitbox_size.y/2)]
	get_window().mouse_passthrough_polygon = hitbox_array
