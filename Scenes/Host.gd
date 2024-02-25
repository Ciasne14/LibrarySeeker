extends Button

func _on_mouse_entered():
	$AudioStreamPlayer3D.play()

func start_as_host():
	print("Host")

func join():
	print("Join")
	
func exit():
	get_tree().quit()


func _on_pressed():
	if(self.name =="Host"):
		start_as_host()
	if(self.name =="Join"):
		join()
	if(self.name =="Exit"):
		exit()
