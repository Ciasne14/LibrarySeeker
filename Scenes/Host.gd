extends Node3D

@onready var address_input = %Address
@onready var host_btn = %Host
@onready var join_btn = %Join
@onready var exit_btn = %Exit
@onready var status_label = %Status

const DEFAULT_PORT = 8910
var peer: ENetMultiplayerPeer

var swapPlayers = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Connect all the callbacks related to networking.
	multiplayer.peer_connected.connect(self._player_connected)
	multiplayer.peer_disconnected.connect(self._player_disconnected)
	multiplayer.connected_to_server.connect(self._connected_ok)
	multiplayer.connection_failed.connect(self._connected_fail)
	multiplayer.server_disconnected.connect(self._server_disconnected)
	host_btn.pressed.connect(self.start_as_host)
	join_btn.pressed.connect(self.join)
	exit_btn.pressed.connect(self.exit)
	
	host_btn.mouse_entered.connect(self._on_mouse_entered)
	join_btn.mouse_entered.connect(self._on_mouse_entered)
	exit_btn.mouse_entered.connect(self._on_mouse_exit_entered)	
	
	var worldEnvironment = WorldEnvironment.new()
	worldEnvironment.name = "WorldEnvironment"
	var env = Environment.new()
	env.background_energy_multiplier = 0
	env.fog_enabled = 1
	env.fog_light_energy = 1
	env.fog_density = 0.0991
	env.fog_sky_affect = 1
	worldEnvironment.environment = env
	get_tree().get_root().add_child.call_deferred(worldEnvironment)
	

# Callback from SceneTree.
func _player_connected(_id):
	load_tutorials()
	hide()
	%CanvasLayer.hide()

func swap():
	swapPlayers = !swapPlayers

func load_tutorials():
	if has_node("/root/Tutorial"):
		get_node("/root/Tutorial").free()
	if (multiplayer.is_server() && swapPlayers == false) || (swapPlayers && multiplayer.is_server() == false):
		load_monster_tutorial()
	else:
		load_capsule_tutorial()
	
func load_monster_tutorial():
	var tutorial = load("res://monster_tutorial.tscn").instantiate()
	get_tree().get_root().add_child(tutorial)
	
func load_capsule_tutorial():
	var tutorial = load("res://librarian_tutorial.tscn").instantiate()
	get_tree().get_root().add_child(tutorial)

func load_library():
	var library = load("res://Scenes/library.tscn").instantiate()
	library.swap = swapPlayers
	get_tree().get_root().add_child(library)


func _player_disconnected(_id):
	if multiplayer.is_server():
		end_game("Client disconnected")
	else:
		end_game("Server disconnected")

# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	pass # This function is not needed for this project.


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	status_label.set_text("Couldn't connect.")

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_btn.set_disabled(false)
	join_btn.set_disabled(false)
	address_input.editable = true


func _server_disconnected():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_game("Server disconnected.")

##### Game creation functions ######

func end_game(with_error = ""):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if has_node("/root/Library"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node(^"/root/Library").free()
	
	if has_node("/root/EndGame"):
		get_node(^"/root/EndGame").delete_it_kurwa()
	
	show()
	%CanvasLayer.show()

	multiplayer.set_multiplayer_peer(null) # Remove peer.
	host_btn.set_disabled(false)
	join_btn.set_disabled(false)
	address_input.editable = true
	peer.close()
	peer = null

	status_label.set_text(with_error)


func _on_mouse_entered():
	if host_btn.disabled == false:
		%AudioStreamPlayer3D.play()

func _on_mouse_exit_entered():
	%AudioStreamPlayer3D.play()

func start_as_host():
	preload("res://Scenes/monster_x.tscn")
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(DEFAULT_PORT, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		status_label.set_text("Can't host, address in use.")
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)

	multiplayer.set_multiplayer_peer(peer)
	host_btn.set_disabled(true)
	join_btn.set_disabled(true)
	address_input.editable = false
	status_label.set_text("Waiting for player...")

func join():
	var ip = address_input.get_text()
	if not ip.is_valid_ip_address():
		status_label.set_text("IP address is invalid.")
		return

	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, DEFAULT_PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	host_btn.set_disabled(true)
	join_btn.set_disabled(true)
	address_input.editable = false

	status_label.set_text("Connecting...")
	
func exit():
	get_tree().quit()
