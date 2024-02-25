extends TextureRect

var waiting = false

@onready var start_btn: Button = %Start

func _ready():
	start_btn.pressed.connect(self._on_start_pressed)

func _on_start_pressed():
	load_blabla.rpc()
	if waiting:
		get_node("/root/Lobby").load_library()
		delete_it_kurwa()
	else:
		start_btn.text = "Waiting for opponent..."
		start_btn.disabled = true
	waiting = true

@rpc("any_peer")
func load_blabla():
	if waiting:
		get_node("/root/Lobby").load_library()
		delete_it_kurwa()
	waiting = true
		

func delete_it_kurwa():
	start_btn.pressed.disconnect(self._on_start_pressed)
	queue_free()
