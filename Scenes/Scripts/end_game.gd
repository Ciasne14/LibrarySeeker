extends Control

var status_text

@onready var status_label = %Status

func _ready():
	if status_text != null:
		status_label.set_text(status_text)


func _on_again_pressed():
	# Someone connected, start the game!
	var library = load("res://Scenes/library.tscn").instantiate()
	get_tree().get_root().add_child(library)
	queue_free()


func _on_swap_pressed():
	var library = load("res://Scenes/library.tscn").instantiate()
	library.swap = true
	get_tree().get_root().add_child(library)
	queue_free()


func _on_lobby_pressed():
	get_node("/root/Lobby").end_game()
	queue_free()
