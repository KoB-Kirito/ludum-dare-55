extends Triggerable


func trigger() -> void:
	%Placeholder.visible = !%Placeholder.visible
	%CollisionShape3D.disabled = !%Placeholder.visible
	#TODO: Play animation of door
