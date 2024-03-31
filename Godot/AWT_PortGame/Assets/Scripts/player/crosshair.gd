## controls the visibility of the crosshair in the middle of the screen

extends Control

@onready var head_raycast: RayCast3D = $"../../Head/RayCast3D"

@export var DOT_RADIUS: float = 2.0
@export var DOT_DEFAULT_COLOR: Color = Color.WHITE
@export var DOT_COLLIDING_COLOR: Color = Color.RED

var HEAD_RAYCAST_COLLIDING: bool = false
var GameManager: Node

func _ready() -> void:
	head_raycast.connect("colliding", toggle_raycast)
	GameManager = get_node("/root/GameScene/GameManager")

func _process(_delta: float) -> void:
	if GameManager.isPlayerDead or GameManager.isGamePaused or GameManager.isInventoryOpen:
		visible = false
	else:
		visible = true
		queue_redraw()

func _draw() -> void:
	if not visible:
		return
	var draw_color: Color = DOT_COLLIDING_COLOR if HEAD_RAYCAST_COLLIDING else DOT_DEFAULT_COLOR
	draw_circle(get_viewport_rect().size / 2, DOT_RADIUS, draw_color)

func toggle_raycast(value: bool) -> void:
	if GameManager.isPlayerDead or GameManager.isGamePaused or GameManager.isInventoryOpen:
		return
	HEAD_RAYCAST_COLLIDING = value
