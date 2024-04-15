extends Node3D

func _ready():
	%InteractLabel.show()
	%ControlsLabel.hide()

func _on_area_3d_body_entered(body):
	if body is Player:
		%ControlsLabel.show()
		%InteractLabel.hide()

func _on_area_3d_body_exited(body):
	if body is Player:
		%InteractLabel.show()
		%ControlsLabel.hide()
