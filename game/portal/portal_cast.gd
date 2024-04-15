extends Node3D


var rays: Array[RayCast3D] = []


func _ready() -> void:
	for c: RayCast3D in get_children():
		rays.append(c)


func is_colliding() -> bool:
	for ray: RayCast3D in rays:
		#ray.force_update_transform()
		#ray.force_raycast_update()
		if ray.is_colliding():
			return true
	
	return false
