extends RigidBody3D

# Exposed variables
var move_speed : float = .01
var detection_radius : float = 8.0
var attack_radius : float = 5.0
var attack_damage : int = 20
var attack_cooldown : float = 3.0

# Private variables
var game_manager : GameManager
var player : Player
var last_attack_time : float

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	player = get_node("/root/GameScene/Player") # Assuming player is a top-level node named "Player"
	game_manager = get_node("/root/GameScene/GameManager")
	
	if player == null:
		printerr("Player not found.")
		set_process(false)
		
	if game_manager == null:
		printerr("GameManager not found.")
		set_process(false)

func _process(delta):
	print(global_transform.origin.distance_to(player.global_transform.origin))
	if player != null and global_transform.origin.distance_to(player.global_transform.origin) <= detection_radius:
		move_towards_player()
		attack_player()

func move_towards_player():
	# Orient the enemy towards the player
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
	
	# Move the enemy in the forward direction
	translate(Vector3.FORWARD * move_speed)

func attack_player():
	pass
	# Assuming GameManager is a singleton and DamagePlayer is a function in that singleton
	#game_manager.damage_player(attack_damage)
