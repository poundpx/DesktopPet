extends PanelContainer
@export var pet_fsm: Node

enum PomoState { IDLE, WORK, BREAK }
var current_state = PomoState.IDLE

var work_duration = 1500
var break_duration = 300
var paused_time = 0.0 

# --- NEW: Cycle Tracking Variables ---
var target_cycles = 4
var cycles_completed = 0

@onready var pomo_timer = $PomodoroTimer
@onready var start_button = $MainStack/Row3_Controls/StartPauseButton
@onready var cancel_button = $MainStack/Row3_Controls/CancelButton

# --- NEW: UI Node References ---
@onready var btn_25 = $MainStack/Row1_Modes/Button25
@onready var btn_50 = $MainStack/Row1_Modes/Button50
@onready var btn_minus = $MainStack/Row2_Cycles/MinusButton
@onready var btn_plus = $MainStack/Row2_Cycles/PlusButton
@onready var cycle_label = $MainStack/Row2_Cycles/CycleLabel

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	pomo_timer.timeout.connect(_on_timer_timeout)
	
	# --- NEW: Connect the new buttons ---
	btn_25.pressed.connect(_on_btn_25_pressed)
	btn_50.pressed.connect(_on_btn_50_pressed)
	btn_minus.pressed.connect(_on_minus_pressed)
	btn_plus.pressed.connect(_on_plus_pressed)
	
	update_cycle_label() # Set the initial text

# --- NEW: Button Functions ---
func _on_btn_25_pressed():
	if current_state == PomoState.IDLE:
		work_duration = 1500
		break_duration = 300
		print("Mode set to 25:5")

func _on_btn_50_pressed():
	if current_state == PomoState.IDLE:
		work_duration = 3000
		break_duration = 600
		print("Mode set to 50:10")

func _on_minus_pressed():
	if current_state == PomoState.IDLE and target_cycles > 1:
		target_cycles -= 1
		update_cycle_label()

func _on_plus_pressed():
	if current_state == PomoState.IDLE:
		target_cycles += 1
		update_cycle_label()

func update_cycle_label():
	# This changes the actual text visible on the screen
	cycle_label.text = str(target_cycles) + " Cycles"

# --- UPDATED: Core Actions ---
func _on_start_pressed():
	match current_state:
		PomoState.IDLE:
			# 1. Trigger the commute instead of the timer
			if pet_fsm:
				start_button.text = "Walking..." 
				pet_fsm.get_parent().start_pomo_commute(self)
			else:
				print("ERROR: pet_fsm is not linked in the Inspector!")
			
		PomoState.WORK, PomoState.BREAK:
			# Keep your existing pause/resume logic exactly as it was
			if pomo_timer.is_stopped():
				pomo_timer.start(paused_time) 
				start_button.text = "Pause"
			else:
				paused_time = pomo_timer.time_left 
				pomo_timer.stop()
				start_button.text = "Resume"

# --- NEW FUNCTION ---
# The pet will call this exactly when it reaches the bottom right corner
func begin_actual_countdown():
	cycles_completed = 0 
	current_state = PomoState.WORK
	pomo_timer.start(work_duration)
	start_button.text = "Pause"
	print("Pet arrived! Starting the clock now.")
	
	# Tell the FSM to play the work animation
	if pet_fsm:
		pet_fsm._pick_pomodoro()

func _on_cancel_pressed():
	pomo_timer.stop()
	current_state = PomoState.IDLE
	start_button.text = "Start"
	cycles_completed = 0
	print("Session Cancelled.")

func _on_timer_timeout():
	if current_state == PomoState.WORK:
		cycles_completed += 1
		
		# --- NEW: Check if we finished all cycles ---
		if cycles_completed >= target_cycles:
			current_state = PomoState.IDLE
			start_button.text = "Start"
			print("All cycles complete! Great job.")
		else:
			current_state = PomoState.BREAK
			pomo_timer.start(break_duration)
			print("Work over! Starting Break. (Completed: " + str(cycles_completed) + "/" + str(target_cycles) + ")")
			
	elif current_state == PomoState.BREAK:
		current_state = PomoState.WORK
		pomo_timer.start(work_duration)
		print("Break over! Starting Work cycle " + str(cycles_completed + 1))
