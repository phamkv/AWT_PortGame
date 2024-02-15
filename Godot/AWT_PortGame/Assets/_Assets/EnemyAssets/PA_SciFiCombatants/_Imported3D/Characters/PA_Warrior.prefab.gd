extends Node3D

# variables
var move_speed : float = .01
var detection_radius : float = 5.0
var attack_radius : float = 2.0
var attack_damage : int = 20
var attack_cooldown : float = 3.0
var health : int = 5

var game_manager : Node
var player : Node
var time_since_last_attack : float = 0.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _ready():
	player = get_node("/root/GameScene/Player")
	game_manager = get_node("/root/GameScene/GameManager")

	
	if player == null:
		printerr("Player not found.")
		set_process(false)
		
	if game_manager == null:
		printerr("GameManager not found.")
		set_process(false)

func _process(delta):
	if player == null:
		return
	var dist = global_transform.origin.distance_to(player.global_transform.origin)
	if dist <= detection_radius:
		move_towards_player()
	if dist <= attack_radius:
		attack_player(delta)

func move_towards_player():
	look_at(player.global_transform.origin, Vector3(0, 1, 0))
	#rotate(Vector3(0, 1, 0), deg_to_rad(180))
	translate(Vector3.FORWARD * move_speed)
	
	#var direction_to_player = (player.global_transform.origin - global_transform.origin).normalized()
	#look_at(player.global_transform.origin, Vector3(0, 1, 0))
	
	#translate(direction_to_player * move_speed)

func attack_player(delta):
	if time_since_last_attack >= attack_cooldown:
		game_manager.DamagePlayer(attack_damage)
		time_since_last_attack = 0.0
	else:
		time_since_last_attack += delta
		
func attack_enemy(damage: int = 1):
	if health < damage:
		queue_free()
	else:
		health -= damage

func interaction(mainHandSlot: Node) -> void:
	if mainHandSlot.GetItemName() == "Sword":
		attack_enemy(3)
	elif mainHandSlot.GetItemName() == "Axe":
		attack_enemy(2)
	else:
		attack_enemy(1)
