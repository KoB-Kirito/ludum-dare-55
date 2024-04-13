extends Triggerable


func trigger() -> void:
	%Tuer2.visible = !%Tuer2.visible
	%CollisionShape3D.disabled = !%Tuer2.visible
	#TODO: Play animation of door
