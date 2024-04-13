extends Node


var last_interactable: Interactable


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and is_instance_valid(last_interactable):
		last_interactable.interact()
