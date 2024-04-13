extends Node3D


func _ready() -> void:
	#TODO: SFX, Animation, Spawn ghost, sound
	%Timer.start()



func _on_timer_timeout() -> void:
	#TODO: Remove sfx
	queue_free()
