extends CharacterBody3D


const SPEED = 20.0
const JUMP_VELOCITY = 10.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var look_dir: Vector2
@onready var camera = $PlayerCamera
var camera_sens = 20

var capMouse = true

func _ready():
	if capMouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("pause"):
		capMouse = !capMouse
		if capMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_rotate_camera(delta)
	move_and_slide()

func _input(event: InputEvent):
	if event is InputEventMouseMotion: look_dir = event.relative * 0.01
	
func _rotate_camera(delta: float, sens_mod: float = 1.0):
	# var input = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	#look_dir += input
	rotation.y -= look_dir.x * camera_sens * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod * delta, deg_to_rad(-40), deg_to_rad(90))
	look_dir = Vector2.ZERO
	
