extends Node

##currently using star as health barr but can be change later 
var current_stars=99;
var max_stars=100
var last_logout_time=1;
var drain_rate=.01;


#---------------------------------------------------------------
#							when START

func _ready():
	DataHandling.load_data()
	#make app not go thru _noti to save before close
	get_tree().set_auto_accept_quit(false)


#timer drain stat for pet that link SIGNAL wih DrainTimer node
#To view signal click on DrainTimer look for right hand side top
#Its next to inspector in signal section
func _on_drain_timer_timeout():
	current_stars -=.1
	print("pet current stars/health: ",current_stars)


#click r to reset save file reset pet stat for testing purpose
func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		DataHandling.reset_save()
		print("Save file deleted! Success")
		

#save pet stats as json file
func save():
	return{
		"current_stars": current_stars,
		"max_stars": max_stars,
		"last_logout_time": last_logout_time,
		"drain_rate": drain_rate	
	}
	

#handle save data before close app completely
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST: 
		DataHandling.save_game()
		get_tree().quit()	#fully close application and exist tree node scene 
	
