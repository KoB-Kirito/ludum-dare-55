extends Node3D


var duration: float

func _ready() -> void:
	#TODO: SFX, Animation, Spawn ghost, sound
	#%Timer.start(duration)
	
	Events.returned_to_host.connect(on_returned_to_host)


func on_returned_to_host() -> void:
	queue_free()
