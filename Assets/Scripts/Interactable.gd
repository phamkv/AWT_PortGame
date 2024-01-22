extends Node3D

@export var replacementObject: PackedScene
@export var dropCount: int = 1

@export var canBePickedUp: bool = false
@export var itemPicture: Texture2D
@export var displayName: String = ""
@export var itemCount: int = 1


var health: int = 5

func _ready():
	pass

func _process(delta):
	pass

func destroy_object():
	for i in range(dropCount):
		var replacementInstance = replacementObject.instantiate()
		get_parent().add_child(replacementInstance)
		
		var randomPosition = Vector3(
			randf_range(-0.5, 0.5),
			randf_range(0.0, 2.5),
			randf_range(-0.5, 0.5)
		)
		replacementInstance.transform.origin = transform.origin + randomPosition
	queue_free()

func pickUp():
	var inventory_node = get_node("/root/GameScene/UI/Player/Inventory")
	if inventory_node:
		inventory_node.AddItemToInventory(displayName, itemPicture, itemCount)
	else:
		print("PlayerInventory not found.")
	queue_free()

func interaction(mainHandSlot: Node) -> void:
	print(mainHandSlot.GetItemName())
	if canBePickedUp:
		pickUp()
	else:
		if mainHandSlot.GetItemName() == "Axe":
			health -= 3
		else:
			health -= 1
		if health < 0:
			destroy_object()
