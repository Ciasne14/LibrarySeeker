extends CharacterBody3D

var MOVE_SPEED = 15
const MOUSE_SENSITIVITY = 1000

@onready var camera: Camera3D = %Camera
@export var worldSettings: WorldEnvironment

@onready var worldASD: WorldEnvironment = get_node("/root/Library/WorldEnvironment")

func _ready():
	if is_multiplayer_authority():
		camera.current = true
		MOVE_SPEED = 30
		worldASD.environment.background_energy_multiplier = 0
	else:
		camera.current = false
		$CameraPivot/SpotLight3D.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	

func _input(event):
	if is_multiplayer_authority() == false:
		return
	if event is InputEventMouseMotion:
		var rot_speed = event.relative/ MOUSE_SENSITIVITY
		rotate_y(-rot_speed.x)
		$CameraPivot.rotate_x(-rot_speed.y)
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -70, 70)

func _process(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if is_multiplayer_authority() == false:
		return
	
	var direction = Vector3()

	if Input.is_action_pressed("move_forward"):
		direction -= $CameraPivot.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += $CameraPivot.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= $CameraPivot.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += $CameraPivot.global_transform.basis.x

	direction.y = 0
	direction = direction.normalized()

	velocity = direction * MOVE_SPEED
	move_and_slide()
