extends TextureRect



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$AnimationPlayer.play("FadeIn")
	$TimerFadeInGameBy.wait_time=3
	$TimerFadeInGameBy.start()


func _on_timer_fade_in_game_by_timeout():
	$AnimationPlayer.play("FadeOut")
	$TimerFadeInFear.wait_time = 3
	$TimerFadeInGameBy.stop()
	$TimerFadeInFear.start()


func _on_timer_fade_in_fear_timeout():
	$".".texture = load("res://Textures/fear.png")
	$AnimationPlayer.play("FadeIn")
	$TimerFadeInFear.stop()
	$LoadMainMenu.wait_time = 7
	$LoadMainMenu.start()

func _on_load_main_menu_timeout():
	$LoadMainMenu.stop()
	$LastFadeOut.wait_time = 3
	$AnimationPlayer.play("FadeOut")
	$LastFadeOut.start()

func _on_last_fade_out_timeout():
	$LastFadeOut.stop()
	var intro = load("res://Scenes/intronecronomicon.tscn").instantiate()
	get_tree().get_root().add_child(intro)
	queue_free()
