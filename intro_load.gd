extends TextureRect



func _ready():
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
	get_tree().quit()
