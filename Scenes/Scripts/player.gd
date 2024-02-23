extends CharacterBody3D

const MOVE_SPEED = 15
const MOUSE_SENSITIVITY = 1000


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		var rot_speed = event.relative/ MOUSE_SENSITIVITY
		rotate_y(-rot_speed.x)
		$CameraPivot.rotate_x(-rot_speed.y)
		$CameraPivot.rotation_degrees.x = clamp($CameraPivot.rotation_degrees.x, -70, 70)

func _process(delta):
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
