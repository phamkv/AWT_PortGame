extends Node3D

@export var replacementObject: PackedScene
@export var dropCount: int = 1

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

func interaction() -> void:
	if health > 0:
		health -= 1
	else:
		destroy_object()
