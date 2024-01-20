extends RayCast3D

signal colliding

func _process(_delta: float) -> void:
	if is_colliding(): 
		#print("hi")
		colliding.emit(true)
	else:
		colliding.emit(false)
