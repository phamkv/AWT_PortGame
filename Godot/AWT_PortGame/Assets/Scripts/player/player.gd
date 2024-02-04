extends CharacterBody3D

enum State {IDLE, WALKING, JUMPING, SPRINTING}

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

@export_group("Properties")
@export_range(1, 10, 0.1) var WALKING_SPEED: float = 3.0
@export_range(1, 10, 0.1) var SPRINTING_SPEED: float = 5.5
@export_range(1, 10, 0.1) var JUMP_VELOCITY: float = 4
@export_range(0, 1, 0.1) var MOUSE_SENSIBILITY: float = 0.2
@export_range(0, 20, 0.1) var LERP_SPEED: float = 10.0
@export_range(1, 10, 0.1) var BOB_FREQ: float = 2.0
@export_range(0, 1, 0.01) var BOB_AMP: float = 0.05

var GameManager: Node
var mainHandItems: Array[Node]
var look_dir: Vector2

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var current_state: State = State.IDLE
var speed: float = WALKING_SPEED
var bob: float = 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager = get_node("/root/GameScene/GameManager")
	mainHandItems = $MainHand.get_children()
	UpdateMainHand("")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative

func _physics_process(delta: float) -> void:
	if (GameManager.isPlayerDead || GameManager.isGamePaused):
		return
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	state_machine()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	move(delta, speed)
	bob += delta * velocity.length() * float(is_on_floor())	

	match current_state:
		State.IDLE:
			pass
			
		State.WALKING:
			speed = WALKING_SPEED
		
		State.JUMPING:
			pass
		
		State.SPRINTING:
			speed = SPRINTING_SPEED

	camera.transform.origin = headbob(bob, BOB_FREQ, BOB_AMP)
	
	if (!GameManager.isInventoryOpen):
		_rotate_camera(delta)
	
	move_and_slide()

func state_machine() -> void:
	if Input.get_vector("left", "right", "forward", "backward") == Vector2.ZERO and is_on_floor():
		current_state = State.IDLE
	if Input.get_vector("left", "right", "forward", "backward") != Vector2.ZERO and is_on_floor():
		current_state = State.WALKING
	if not is_on_floor():
		current_state = State.JUMPING
	if Input.get_vector("left", "right", "forward", "backward") != Vector2.ZERO and Input.is_action_pressed("sprint") and is_on_floor():
		current_state = State.SPRINTING

func move(delta: float, movement_speed: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * movement_speed
			velocity.z = direction.z * movement_speed
		else:
			velocity.x = lerp(velocity.x, direction.x * LERP_SPEED, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * LERP_SPEED, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * JUMP_VELOCITY, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * JUMP_VELOCITY, delta * 2.0)

func _updateRayCast() -> void:
	var raycast = $RayCast3D  # Adjust the path according to your scene structure

	# Set the initial ray direction
	var initial_ray_dir = Vector3(0, 0, -1)

	# Apply rotation to the ray direction using rotate method
	var rotated_ray_dir = initial_ray_dir.rotated(Vector3(1, 0, 0), head.rotation.x)
	rotated_ray_dir = rotated_ray_dir.rotated(Vector3(0, 1, 0), rotation.y)

	# Set the ray's direction directly
	raycast.cast_to = rotated_ray_dir

	# Set the ray's origin to the head's position
	raycast.translation = head.global_transform.origin





func _rotate_camera(_delta: float, _sens_mod: float = 1.0):
	rotate_y(deg_to_rad(-look_dir.x * MOUSE_SENSIBILITY))
	head.rotate_x(deg_to_rad(-look_dir.y * MOUSE_SENSIBILITY))
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	#$RayCast3D.rotate_x(deg_to_rad(-look_dir.y * MOUSE_SENSIBILITY))
	#$RayCast3D.rotation.x = clamp(head.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	#_updateRayCast()  # Call the method to update RayCast3D
	look_dir = Vector2.ZERO

func headbob(time: float, freq: float, amp: float) -> Vector3:
	var pos: Vector3 = Vector3.ZERO
	pos.y = sin(time * freq) * amp
	
	return pos
	
func UpdateMainHand(itemName: String):
	for item in mainHandItems:
		if (item.name == itemName):
			item.show()
		else:
			item.hide()
