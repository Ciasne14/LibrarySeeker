extends Node3D

func _process(delta):
	if Input.is_action_pressed("escape"):
		load_main_menu()

func _on_audio_stream_player_3d_2_finished():
	$AnimationPlayer.play("Fadeeeout")
	$LectorTimer.start()

func load_main_menu():
	var main_menu = load("res://Scenes/main_menu.tscn").instantiate()
	get_tree().get_root().add_child(main_menu)
	queue_free()


func _on_lector_timer_timeout():
	$LectorTimer.stop()
	load_main_menu()
