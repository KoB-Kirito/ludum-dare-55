extends Node3D


var duration: float

func _ready() -> void:
	#TODO: SFX, Animation, Spawn ghost, sound
	%Timer.start(duration)



func _on_timer_timeout() -> void:
	#TODO: Remove sfx
	queue_free()
