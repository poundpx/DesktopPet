extends Node

enum State {
	IDLE,
	WALK,
	PICKUP,
	DRAG,
	INTERACT
}

var current_state = State.IDLE
var state_timer = 0.0
var state_duration = 0.0
var velocity = Vector2.ZERO
@onready var anim = get_parent().get_node("AnimatedSprite2D")

func _ready():
	_pick_idle()
	
func _process(delta):
	state_timer +=delta
	
	match current_state:
		State.IDLE:
			_state_idle()
		State.WALK:
			_state_walk()
		State.DRAG:
			_state_drag()
		State.INTERACT:
			_state_interact()
		State.PICKUP:
			_state_pickup()

func _state_idle():
	get_parent().isWalking = false;
	anim.play("idle")
	print("idling")
	if state_timer >= state_duration:
		_pick_walk()

func _state_walk():
	get_parent().isWalking = true
	anim.play("walk")
	print("walk")
	anim.flip_h = get_parent().walk_direction < 0
	if state_timer >= state_duration:
		_pick_idle()

func _state_interact():
	get_parent().isWalking = false
	anim.play("Interact")
	if state_timer >= state_duration:
		_pick_idle()

func _state_pickup():
	get_parent().isWalking = false
	anim.play("pickup")
	await anim.animation_finished
	_pick_drag()
		
func _state_drag():
	print("Dragging commence")
	get_parent().isWalking = false
	anim.play("in-air")
	
		

#change state 
func _pick_drag():
	current_state = State.DRAG

func _pick_pickup():
	current_state = State.PICKUP
	
func _pick_idle():
	current_state = State.IDLE
	state_timer = 0.0
	state_duration = randf_range(4.0, 7.0)
	
func _pick_walk():
	current_state = State.WALK
	state_timer = 0.0
	state_duration = randf_range (3.0, 6.0)
	
	get_parent().walk_direction = [-1,1].pick_random()

func _pick_interact():
	current_state = State.INTERACT
	state_timer = 0.0
	state_duration = 1.7
# for later implement
func start_drag():
	pass
func stop_drag():
	_pick_idle()
