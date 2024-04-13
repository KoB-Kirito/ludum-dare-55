class_name Interactable
extends Node3D


func _ready() -> void:
	for n in get_children():
		if n is Area3D:
			n.body_entered.connect(on_body_entered)
			return


func on_body_entered(body: Node3D) -> void:
	if body is Player:
		InteractionManager.last_interactable = self


func interact() -> void:
	pass
