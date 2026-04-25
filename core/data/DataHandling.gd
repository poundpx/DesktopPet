extends Node

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
	
	PetStat.current_stars =data.get("current_stars",99)
	PetStat.max_stars = data.get("max_stars",100)
	PetStat.last_logout_time = data.get("last_logout_time", 1)
	PetStat.drain_rate = data.get("drain_rate", 1)
		
		
#reset save by remove file so can create new one 
func reset_save():
	if FileAccess.file_exists("user://PetSave.save"):
		DirAccess.remove_absolute("user://PetSave.save")
