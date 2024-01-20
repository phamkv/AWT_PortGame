extends Node3D

@export var replacementObject: PackedScene

var health: int = 5


func _ready():
	pass



func _process(delta):
	pass
	

func destroy_object():
	var replacementInstance = replacementObject.instantiate()
	get_parent().add_child(replacementInstance)
	
	replacementInstance.transform.origin = transform.origin

	queue_free()

func interaction() -> void:
	if health > 0:
		health -= 1
	else:
		destroy_object()
