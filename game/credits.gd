extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#beendet das Credits Level und zeigt einen Endscreen
func _on_area_3d_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file("res://game/endscene.tscn")
