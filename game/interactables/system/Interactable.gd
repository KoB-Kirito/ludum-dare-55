class_name Interactable
extends Node3D


@export var area: Area3D


func _enter_tree() -> void:
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)



func on_body_entered(body: Node3D) -> void:
	if body is Player:
		InteractionManager.last_interactable = self


func on_body_exited(body: Node3D) -> void:
	if body is Player:
		InteractionManager.last_interactable = null


func interact() -> void:
	pass
