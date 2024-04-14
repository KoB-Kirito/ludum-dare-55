extends Triggerable


func trigger() -> void:
	visible = !visible
	%CollisionShape3D.disabled = !visible
	#TODO: Play animation of door

func _process(delta: float) -> void:
