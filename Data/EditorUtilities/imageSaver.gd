tool
extends Sprite


export (bool) var save_image_input = false setget save_image



func save_image(_sv_im : bool):
	save_image_input = _sv_im
	if(Engine.editor_hint):
		if(_sv_im == true):
			
			get_num_files("res://Data/BG/NoiseTextures/")
			var num_name : String = str(get_num_files("res://Data/BG/NoiseTextures/"))
			var img : Image = texture.get_data()
			
			img.save_png("res://Data/BG/NoiseTextures/" + "noiseTex" + num_name + ".png")
			
			save_image_input = false
			property_list_changed_notify()
			
			pass
		
		pass
	
	pass

func get_num_files(dir_path : String) -> int:
	
	var numfiles : int = 0
	var dir : Directory = Directory.new()
	
	if(dir.open(dir_path) == OK):
		
		dir.list_dir_begin(true, true)
		while true:
			var file_name : String = dir.get_next()
			if(file_name == ""):
				break
			else:
				numfiles += 1
			
		
	
	print(numfiles)
	return numfiles
	
	pass
