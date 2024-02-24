extends CharacterBody3D

var MOVE_SPEED = 15
var DASH_SPEED = 0
var DASH_AVAILABLE = true
const MOUSE_SENSITIVITY = 1000
var audio_player
@onready var camera: Camera3D = %Camera

@onready var worldEnvironment: WorldEnvironment = get_node("/root/Library/WorldEnvironment")
@onready var stepTimer: Timer = $StepTimer
@onready var scream_sound: AudioStreamPlayer3D = $Scream

var stepStart = false

func _ready():
	if is_multiplayer_authority():
		camera.current = true
		MOVE_SPEED = 30
		worldEnvironment.environment.background_energy_multiplier = 0
		#$PlayerArea.area_shape_entered.connect(self._on_area_3d_area_enxtered)
	else:
		camera.current = false
		$Capsule.show()
		$monsterX.hide()
		$CameraPivot/SpotLight3D.hide()
	audio_player = $Heels
	$PlayerArea.body_entered.connect(self._on_area_3d_area_entered)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	print(IP.resolve_hostname(str(OS.get_environment("Laptop-Lenovo")),1))
		
	
func _input(event):
	if is_multiplayer_authority() && event is InputEventMouseMotion:
		var rot_speed = event.relative/ MOUSE_SENSITIVITY
		rotate_y(-rot_speed.x)
		$CameraPivot.rotate_x(-rot_speed.y)
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -70, 70)

func _process(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var direction = Vector3()
	var isBtnPressed = false

	if Input.is_action_pressed("move_forward") && is_multiplayer_authority():
		isBtnPressed = true
		direction -= $CameraPivot.global_transform.basis.z
	if Input.is_action_pressed("move_backward") && is_multiplayer_authority():
		isBtnPressed = true
		direction += $CameraPivot.global_transform.basis.z
	if Input.is_action_pressed("move_left") && is_multiplayer_authority():
		isBtnPressed = true
		direction -= $CameraPivot.global_transform.basis.x
	if Input.is_action_pressed("move_right") && is_multiplayer_authority():
		isBtnPressed = true
		direction += $CameraPivot.global_transform.basis.x
	if Input.is_action_pressed("dash") && !is_multiplayer_authority() && DASH_AVAILABLE:
		isBtnPressed = true
		DASH_SPEED = 1000
		DASH_AVAILABLE=false
		$DashTimer.start()
		
	if !is_multiplayer_authority() && isBtnPressed && stepStart == false:
		stepStart = true 
		stepTimer.start(.1)

	if is_multiplayer_authority():
		direction.y = 0
		direction = direction.normalized()
		velocity = direction * (MOVE_SPEED+DASH_SPEED)
		if velocity.length() > 0:
			if !audio_player.playing:
				audio_player.play()
		else:
			if audio_player.playing:
				audio_player.stop()
	DASH_SPEED = 0
	move_and_slide()


func _on_dash_timer_timeout():
	DASH_AVAILABLE=true
	

func _on_area_3d_area_entered(area):
	print(area.name)
	#if area.name == "Player2":
		#scream_sound.playing = true
		#await scream_sound.finished
		#var end_game = load("res://Scenes/end_game.tscn").instantiate()
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().get_root().add_child(end_game)
		#get_node("/root/Library").queue_free()
	#if area.name == "Ending":
		#print ("GG Easy")


func _on_step_timer_timeout():
	stepStart = false
	stepTimer.stop()
	var step = load("res://Scenes/step.tscn").instantiate()
	step.position = position
	step.position.y = 0.2
	step.rotation = rotation
	get_node("/root/Library").add_child(step)
