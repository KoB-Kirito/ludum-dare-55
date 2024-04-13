class_name Interactable
extends Node3D


func _ready() -> void:
	for n in get_children():
		if n is Area3D:
			n.body_entered.connect(on_body_entered)
			n.body_exited.connect(on_body_exited)
			return


func on_body_entered(body: Node3D) -> void:
	if body is Player:
		InteractionManager.last_interactable = self


func on_body_exited(body: Node3D) -> void:
	if body is Player:
		InteractionManager.last_interactable = null


func interact() -> void:
	pass
