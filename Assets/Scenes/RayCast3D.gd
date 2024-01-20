extends RayCast3D

signal colliding

func _process(_delta: float) -> void:
	if is_colliding(): 
		colliding.emit(true)

		if Input.is_action_just_pressed("interact"):
			var collided_object = get_collider()
			
			if collided_object and collided_object.has_method("interaction"):
				collided_object.interaction()
	else:
		colliding.emit(false)
