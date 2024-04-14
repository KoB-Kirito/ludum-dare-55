extends Node3D
## Teleports player to it's position at start, then removes itself


@export var enabled: bool = true


func _ready() -> void:
	if enabled:
		var player: Player = get_tree().get_first_node_in_group("player")
		if is_instance_valid(player):
			player.global_position = global_position
	
	queue_free()
