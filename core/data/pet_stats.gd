extends Node

##currently using star as health barr but can be change later 
var current_stars=99;
var max_stars=100
var last_logout_time=1;
var drain_rate=.01;

#---------------------------------------------------------------
#							when START

func _ready():
	load_data()
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
	if event.is_action_pressed("r"):
		reset_save()
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
		save_game()
		get_tree().quit()	#fully close application and exist tree node scene 
	


#--------------------------------------------------------
#					SAVE AND LOAD ( seperate later)

#Save pet data to file go through each node in tree scene tscn
#Then get the stat and make it into json format and save 
func save_game():
	var save_file = FileAccess.open("user://PetSave.save",FileAccess.WRITE) 
	
	#find group look right hand side on top next to inspector and signal in scene groups
	var save_nodes = get_tree().get_nodes_in_group("Pet")
	
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("	persistent node '%s' is not an instanced scene, skipped" %node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		var node_data = node.call("save")			#call save func
		var json_string = JSON.stringify(node_data)	#convert to 
		
		print(json_string) 	 
		save_file.store_line(json_string)

#Load pet data from file to game if exist if not use preset stat
#if file not exist fall back to default stat
func load_data():
	if !FileAccess.file_exists("user://PetSave.save"):
		print("Save file is empty, using default pet stats")
		return 
	
	var save_file = FileAccess.open("user://PetSave.save", FileAccess.READ)
	var save_text = save_file.get_as_text()
	
	if save_text.is_empty():
		print("Save file is empty, using default pet stats")
		return
	var data = JSON.parse_string(save_text)
	
	current_stars =data.get("current_stars",99)
	max_stars = data.get("max_stars",100)
	last_logout_time = data.get("last_logout_time", 1)
	drain_rate = data.get("drain_rate", 1)
		
		
#reset save by remove file so can create new one 
func reset_save():
	if FileAccess.file_exists("user://PetSave.save"):
		DirAccess.remove_absolute("user://PetSave.save")
