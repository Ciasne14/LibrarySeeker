extends Node3D

signal game_finished()

@onready var player2 = %Monster
@onready var player = %Capsule

var swap = false
var timeLeft = 0
var maxTime = 180

func _ready():
	# By default, all nodes in server inherit from master,
	# while all nodes in clients inherit from puppet.
	# set_multiplayer_authority is tree-recursive by default.
	if swap:
		var tmp = player2
		player2 = player
		player = tmp
	
	if multiplayer.is_server():
		# For the server, give control of player 2 to the other peer.
		player.set_multiplayer_authority(multiplayer.get_peers()[0])
		player2.set_multiplayer_authority(multiplayer.get_unique_id())
	else:
		# For the client, give control of player 2 to itself.
		player.set_multiplayer_authority(multiplayer.get_unique_id())
		player2.set_multiplayer_authority(multiplayer.get_peers()[0])
		
	player.setup()
	player2.setup()

	print("Is server: ", multiplayer.is_server())
	print("Me: ", multiplayer.get_unique_id())
	print("Other Player: ", multiplayer.get_peers())
#
#func _physics_process(delta):
	#if Input.is_action_pressed("ui_cancel"):
		#game_finished.emit()


func _on_end_game_timer_timeout():
	timeLeft = timeLeft+ 1
	if (timeLeft<maxTime):
		$CountDown.text = ("Time left: " & maxTime-timeLeft)
	if timeLeft == 0:
		print ("time out")
