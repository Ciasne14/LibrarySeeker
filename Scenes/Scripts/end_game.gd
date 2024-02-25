extends Control

var win = false
var monster = false

@onready var status_label = %Status
@onready var scream: AudioStreamPlayer = $Scream

@onready var again_btn: Button = %Again
@onready var swap_btn: Button = %Swap
@onready var lobby_btn: Button = %Lobby

var button_pressed_value = ""

func _ready():
	if win:
		status_label.set_text("You Win!!")
	else:
		status_label.set_text("You Loose...")
	if monster == false && win == false:
		scream.play()
	again_btn.pressed.connect(self._on_again_pressed)
	swap_btn.pressed.connect(self._on_swap_pressed)
	lobby_btn.pressed.connect(self._on_lobby_pressed)
	
@rpc("any_peer")
func button_pressed(btn: String):
	print("button_pressed invoked!")
	check_load(btn)
	if button_pressed_value == "":
		status_label.set_text("Opponent choosed: " + btn)
	button_pressed_value = btn

func _on_again_pressed():
	button_pressed.rpc("again")
	check_load("again")
	button_pressed_value = "again"
	again_btn.disabled = true
	swap_btn.disabled = true
	lobby_btn.disabled = true
	status_label.set_text("Waiting for opponent...")

func _on_swap_pressed():
	button_pressed.rpc("swap")
	check_load("swap")
	button_pressed_value = "swap"
	again_btn.disabled = true
	swap_btn.disabled = true
	lobby_btn.disabled = true
	status_label.set_text("Waiting for opponent...")


func _on_lobby_pressed():
	button_pressed.rpc("lobby")
	check_load("lobby")
	button_pressed_value = "lobby"
	again_btn.disabled = true
	swap_btn.disabled = true
	lobby_btn.disabled = true
	status_label.set_text("Waiting for opponent...")

func check_load(clicked_value):
	if clicked_value == "" || button_pressed_value == "":
		return
	
	if button_pressed_value == clicked_value:
		fire_btn(clicked_value)
		return
	
	if button_pressed_value == "again" && clicked_value == "swap":
		fire_btn("swap")
		return
	
	if button_pressed_value == "swap" && clicked_value == "again":
		fire_btn("swap")
		return
	
	if button_pressed_value == "lobby" || clicked_value == "lobby":
		fire_btn("lobby")
		return
	
func fire_btn(value):
	print("fire btn " + value)
	if value == "lobby":
		get_node("/root/Lobby").end_game()
		delete_it_kurwa()
		return
	
	load_library(value == "swap")

func load_library(swap: bool = true):
	var library = load("res://Scenes/library.tscn").instantiate()
	library.swap = swap
	get_tree().get_root().add_child(library)
	delete_it_kurwa()

func delete_it_kurwa():
	again_btn.pressed.disconnect(self._on_again_pressed)
	swap_btn.pressed.disconnect(self._on_swap_pressed)
	lobby_btn.pressed.disconnect(self._on_lobby_pressed)
	queue_free()
